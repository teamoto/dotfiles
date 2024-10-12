#!/bin/bash

set -euo pipefail

# Environment variables
## Change these variables to suit your needs.
BACKUP_RETENTION=7


## Do not change these variables.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${HOME}/.dotfiles"
DEFAULT_COLOR="\033[0m"
YELLOW_COLOR="\033[1;33m"
RED_COLOR="\033[1;31m"



# Functions
function time_echo() {
    # Print a message with a timestamp.
    local message="$1"
    local date_time=$(date +'%Y-%m-%d %H:%M:%S')
    local color="$2"
    echo -e "${color}${date_time} - ${message}${DEFAULT_COLOR}"
}

function info() {
    local message="$1"
    time_echo "INFO: ${message}" "${DEFAULT_COLOR}"
}

function warn() {
    local message="$1"
    time_echo "WARN: ${message}" "${YELLOW_COLOR}"
}

function error() {
    local message="$1"
    time_echo "ERROR: ${message}" "${RED_COLOR}"
}

function backup_dotfiles() {
    # Backup the existing dotfiles.
    local backup_dir="${DOTFILES_DIR}/backup/$(date +'%Y-%m-%d_%H-%M-%S')"
    local backup_count
    local excess_basckups

    info "Creating a backup directory if it does not exist..."
    mkdir -p "${backup_dir}"
    info "Backing up the existing dotfiles..."
    find "${DOTFILES_DIR}/" -maxdepth 1 -mindepth 1 -not -name backup | xargs -I {} mv {} "${backup_dir}/"

    # Remove old backups.
    info "Checking the number of backups..."
    backup_count=$(ls -1 "${DOTFILES_DIR}/backup" | wc -l)
    if [[ "${backup_count}" -gt "${BACKUP_RETENTION}" ]]; then
        info "Removing old backups..."
        excess_backups=$((backup_count - BACKUP_RETENTION))
        warn "Removing ${excess_backups} old backups..."
        find "${DOTFILES_DIR}/backup" -mindepth 1 -maxdepth 1 -type d -printf '%T+ %p\n' | \
            sort | head -n "${excess_backups}" | cut -d' ' -f2- | xargs -I {} rm -rf {}
    fi

}

function is_installed() {
    # Check if a command is installed.
    local command="$1"
    if command -v "${command}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

function configure_vim() {
    if is_installed "vim"; then
        if ln -s "${DOTFILES_DIR}/.vimrc" "${HOME}/.vimrc"; then
            info "Created a symbolic link to the .vimrc file."
        else
                warn "Failed to create a symbolic link to the .vimrc file. The file already exists."
        fi
    else
        warn "Vim is not installed."
    fi
}

# Main function to configure the dotfiles.
function main() {
    # Create the dotfiles directory if it does not exist.
    info "Creating the dotfiles directory..."
    if [[ ! -d "${DOTFILES_DIR}" ]]; then
        mkdir -p "${DOTFILES_DIR}"
    else
        warn "The dotfiles directory already exists."
        info "Creating a backup of the existing dotfiles directory..."
        backup_dotfiles
    fi

    # Copy the dotfiles to the dotfiles directory.
    if [[ $(find "${DOTFILES_DIR}/" -maxdepth 1 -mindepth 1 -not -name backup | wc -l) -eq 0 ]]; then
        warn "The dotfiles directory is empty."
    fi

    info "Copying the dotfiles to the dotfiles directory..."
    cp -r "${SCRIPT_DIR}/dotfiles/." "${DOTFILES_DIR}/"

    # Create symbolic links to the dotfiles.
    
    configure_vim
}

main "$@"