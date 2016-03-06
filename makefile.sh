#!/usr/bin/env bash

# Workspace
USER_NAME=$(logname)
USER_HOME=$(sudo -u ${USER_NAME} -H sh -c 'echo "$HOME"')
CURRENT_SHELL="$(if [ ! -z "$ZSH_NAME" ]; then echo 'zsh'; else echo 'bash'; fi)"
CURRENT_USER="$USER"
CURRENT_OS=$(uname -s)
SCRIPT_ROOT=$(pwd)

if [[ "$CURRENT_SHELL" == "bash" ]]; then
    if [[ "$CURRENT_OS" = "Darwin" || "$CURRENT_OS" = "FreeBSD" ]]; then
        BASH_RC="${USER_HOME}/.profile"
    else
        BASH_RC="${USER_HOME}/.${CURRENT_SHELL}rc"
    fi
else
    BASH_RC="${USER_HOME}/.${CURRENT_SHELL}rc"
fi

ALREADY_DONE=$(grep "alias gitwib" ${BASH_RC})
if [[ -z "$ALREADY_DONE" ]]; then
    echo "" >> "${BASH_RC}"
    echo "# Added by GitWib makefile" >> "${BASH_RC}"
    echo "alias gitwib='${SCRIPT_ROOT}/gitwib.sh'" >> "${BASH_RC}"

    source "${BASH_RC}"
    if [[ $? -eq 0 ]]; then
        echo "Success to create gitwib alias"
    else
        echo "Fail to create gitwib alias"
    fi
else
    echo "Creation of gitwib alias already done"
fi