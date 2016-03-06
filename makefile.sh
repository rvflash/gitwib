#!/usr/bin/env bash

##
# GitWib: Git Where Is my Branch ?
#
# Install gitwib command line tool
#
# @copyright 2015 Hervé Gouchet
# @license http://www.apache.org/licenses/LICENSE-2.0
# @source https://github.com/rvflash/gitwib

# Workspace
userHome=$(sudo -u $(logname) -H sh -c 'echo "$HOME"')
shell=$(if [ ! -z "$ZSH_NAME" ]; then echo 'zsh'; else echo 'bash'; fi)
os=$(uname -s)
rootDir=$(pwd)

if [[ "$shell" == "bash" ]]; then
    if [[ "$os" = "Darwin" || "$os" = "FreeBSD" ]]; then
        bashFile="${userHome}/.profile"
    else
        bashFile="${userHome}/.${shell}rc"
    fi
else
    bashFile="${userHome}/.${shell}rc"
fi

if [[ -z "$(grep "alias gitwib" ${bashFile})" ]]; then
    echo  >> "${bashFile}"
    echo "# Added by GitWib makefile" >> "${bashFile}"
    echo "alias gitwib='${rootDir}/gitwib.sh'" >> "${bashFile}"

    source "${bashFile}"
    if [[ $? -eq 0 ]]; then
        echo "Success to create gitwib alias"
    else
        echo "Fail to create gitwib alias"
    fi
else
    echo "Creation of gitwib alias already done"
fi