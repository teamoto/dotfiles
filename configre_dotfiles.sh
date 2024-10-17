#!/bin/bash

set -euo pipefail

# Environment variables
## Change these variables to suit your needs.
BACKUP_RETENTION=7
## Should you need to use any tmux plugins, ensure to set the TMUX_PLUGIN_MANAGER variable.
TMUX_PLUGIN_MANAGER="tmux-plugins/tpm"
## Should you need to use any vscode extensions, ensure to set the VSCODE_EXTENSIONS variable.
VSCODE_EXTENSIONS=(
    "donjayamanne.githistory"
    "editorconfig.editorconfig"
    "esbenp.prettier-vscode"
    "github.copilot"
    "github.copilot-chat"
    "gruntfuggly.todo-tree"
    "hediet.vscode-drawio"
    "mads-hartmann.bash-ide-vscode"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "oderwat.indent-rainbow"
    "rogalmic.bash-debug"
    "shd101wyy.markdown-preview-enhanced"
    "streetsidesoftware.code-spell-checker"
    "teabyii.ayu"
    "usernamehw.errorlens"
    "vscode-icons-team.vscode-icons"
    "wayou.vscode-todo-highlight"
    "yzhang.markdown-all-in-one"
)


## Do not change these variables.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${HOME}/.dotfiles"


# Functions
# Import the base functions
source "${SCRIPT_DIR}/utils/base_functions.sh"

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

# Vim
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

# Tmux
## Tmux plugins
function install_tmux_plugins() {
    if ! is_installed "tmux" && ! is_installed "git"; then
        warn "Tmux or git is not installed."
        return 0
    fi
    if [[ ! -z "${TMUX_PLUGIN_MANAGER}" ]]; then
        if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
            info "Cloning the tmux plugin manager..."
            git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        fi
    fi

}

## Tmux configuration
function configure_tmux() {
    if is_installed "tmux"; then
        if ln -s "${DOTFILES_DIR}/.tmux.conf" "${HOME}/.tmux.conf"; then
            info "Created a symbolic link to the .tmux.conf file."
        else
            warn "Failed to create a symbolic link to the .tmux.conf file. The file already exists."
        fi
    else
        warn "Tmux is not installed."
        return 0
    fi
    install_tmux_plugins
    tmux source "${HOME}/.tmux.conf"
}

# vscode

# ToDo:
# - Add a function to detect the OS.
# - Add functions and shortcut keys tailored for MacOS.


## Install extensions
function install_vscode_extension() {
    local extension="$1"
    if [[ -z "${extension}" ]]; then
        error "No extension provided."
        return 1
    fi
    info "Installing the ${extension} extension..."
    if grep -q "${extension}" <<<$(code --list-extensions); then
        warn "The ${extension} extension is already installed. Skipping..."
    else
        if code --install-extension "${extension}"; then
            info "The ${extension} extension was successfully installed."
        else
            warn "Failed to install the ${extension} extension."
        fi
    fi
    return 0
}

## Backup the current vscode settings and keybindings
function backup_vscode_setting() {
    local user_config_dir="${HOME}/.config/Code/User"
    local backup_dir="${HOME}/.config/Code/User/backup"

    if [[ ! -d "${backup_dir}" ]]; then
        info "Creating the vscode user configuration backup directory..."
        mkdir -p "${backup_dir}"
    fi

    info "Backing up the vscode user configuration..."
    if [[ -f "${user_config_dir}/settings.json" ]]; then
        info "Backing up the vscode settings..."
        cp -f "${user_config_dir}/settings.json" "${backup_dir}/settings.json"
    else
        warn "The vscode settings file does not exist."
        return 1
    fi
    info "Backing up the vscode keybindings..."
    if [[ -f "${user_config_dir}/keybindings.json" ]]; then
        cp -f "${user_config_dir}/keybindings.json" "${backup_dir}/keybindings.json"
    else
        warn "The vscode keybindings file does not exist."
        return 1
    fi
    return 0
}

## Configure vscode settings and keybindings
function configure_vscode() {
    local user_config_dir="${HOME}/.config/Code/User"

    info "Checking if VSCode is installed..."
    if ! is_installed "code"; then
        warn "VSCode is not installed."
        return 0
    fi

    if [[ ! -d "${user_config_dir}" ]]; then
        info "Creating the vscode user configuration directory..."
        mkdir -p "${user_config_dir}"
    fi

    backup_vscode_setting

    info "Overwriting the vscode settings..."
    cp -f "${DOTFILES_DIR}/vscode/settings.json" "${user_config_dir}/settings.json"
    info "Overwriting the vscode keybindings..."
    cp -f "${DOTFILES_DIR}/vscode/keybindings.json" "${user_config_dir}/keybindings.json"

    info "Installing the vscode extensions..."
    for extension in "${VSCODE_EXTENSIONS[@]}"; do
        install_vscode_extension "${extension}"
    done

}


# Main
## Main function to configure the dotfiles.
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
    configure_tmux
    configure_vscode


    info "Dotfiles configuration successfully complated."
}

main "$@"
