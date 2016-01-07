#!/usr/bin/env bash

##
# GitWib: Git Where Is my Branch ?
# Provide interface to search a branch by name in all local or remote git repositories

# Workspace
SCRIPT=$(basename ${BASH_SOURCE[0]})
WRK_DIR=$(pwd)
GIT_LOCAL=0

# Usage
function usage ()
{
    echo "Usage: ${SCRIPT} -b branch_name [-d home_workspace] [-l]"
    echo "-b Branch named to search"
    echo "-d Root directory with GIT repositories"
    echo "-l used keep in local search"

    if [ "$1" = "GIT" ]; then
        echo "> GIT in command line is required"
    fi
}

##
# Exit in error case
# @param string $1 return code of previous step
# @param string $2 message to log
function exitOnError ()
{
    if [ "$1" -ne 0 ]; then
        echo "$2"
        exit $1;
    fi
}

##
# @param string $1 Branch name
# @param string $2 Home of worskspace (root of GIT repositories to check
# @param int $3 Local search if 1, remote search otherwise
function gitwib ()
{
    local WRK_DIR="$2"
    local GIT_BRANCH="$1"
    local GIT_LOCAL="$3"

    declare -a GIT_REPOSITORIES="($(find "${WRK_DIR%/}" -name ".git" -type d 2>> /dev/null))"
    exitOnError $? "Unable to access to $1"

    local GIT_REPOSITORY_NB="${#GIT_REPOSITORIES[@]}"
    if [ "$GIT_REPOSITORY_NB" -eq 0 ]; then
        echo "No GIT repository to fetch"
        return 1
    fi

    local FOUND=""
    for REPOSITORY in ${GIT_REPOSITORIES[@]}; do
        if ([ "$GIT_LOCAL" -eq 0 ] && [ -n "$(cd "$REPOSITORY" && git remote show origin | grep -E "\*?[[:space:]]${GIT_BRANCH}")" ]) ||
           ([ "$GIT_LOCAL" -eq 1 ] && [ -n "$(cd "$REPOSITORY" && git branch | grep -E "\*?[[:space:]]${GIT_BRANCH}")" ]); then
            if [ -n "$FOUND" ]; then
                FOUND+="\n"
            fi
            FOUND+="Branch named ${GIT_BRANCH} was found in the repository ${REPOSITORY}"
        fi
    done

    if [ -z "$FOUND" ]; then
        if [ "$GIT_REPOSITORY_NB" -eq 1 ]; then
            echo "Branch name ${GIT_BRANCH} was not found in ${GIT_REPOSITORY_NB} GIT repository"
        else
            echo "Branch name ${GIT_BRANCH} was not found in ${GIT_REPOSITORY_NB} GIT repositories"
        fi
    else
        echo -e "$FOUND"
    fi
}

# Script usage & check if mysql is availabled
if [ $# -lt 1 ]; then
    usage
    exit 1
elif ! GIT_PATH="$(type -p git)" || [ -z "$GIT_PATH" ]; then
    usage GIT
    exit 2
fi

# Read the options
# Use getopts vs getopt for MacOs portability
while getopts "b::d:l" FLAG; do
    case "${FLAG}" in
        b) GIT_BRANCH="$OPTARG" ;;
        d) if [ "${OPTARG:0:1}" = "/" ]; then WRK_DIR="$OPTARG"; else WRK_DIR="${WRK_DIR}${OPTARG}"; fi ;;
        l) GIT_LOCAL=1 ;;
        *) usage; exit 1 ;;
        ?) exit 2 ;;
    esac
done
shift $(( OPTIND - 1 ));

# Mandatory options
if [ -z "$GIT_BRANCH" ]; then
    usage
    exit 1
fi

gitwib "$GIT_BRANCH" "$WRK_DIR" "$GIT_LOCAL"