#!/bin/bash

# This script contains functions that could be used in other scripts.
set -euo pipefail

# Environment variables
DEFAULT_COLOR="\033[0m"
YELLOW_COLOR="\033[1;33m"
RED_COLOR="\033[1;31m"

# Functions

## Function to print a message with a timestamp.
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

## Function to check if a given command is installed.
function is_installed() {
    # Check if a command is installed.
    local command="$1"
    if command -v "${command}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}