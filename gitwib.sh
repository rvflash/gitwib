#!/usr/bin/env bash

##
# GitWib: Git Where Is my Branch ?
#
# Provide interface to search a branch by name in all local or remote GIT repositories
#
# @copyright 2015 Hervé Gouchet
# @license http://www.apache.org/licenses/LICENSE-2.0
# @source https://github.com/rvflash/gitwib


# Constants
declare -r GW_COLOR_BLUE='\033[0;34m'
declare -r GW_COLOR_RED='\033[0;91m'
declare -r GW_COLOR_OFF='\033[0m'

# Workspace
declare -- branchName=""
declare -- wrkDir="$(pwd)"
declare -i remoteBranch=1


##
# Usage
# @param string $1 Error
# @return string
function usage ()
{
    local errorName="$1"

    echo "usage: gitwib -b branch [-d rootDirectory] [-l]"
    echo "-b Branch named to search"
    echo "-d Root directory with GIT repositories to explore"
    echo "-l used to keep in local search"
    echo

    if [[ "$errorName" == "GIT" ]]; then
        echo "> GIT command line tool is required"
    fi
}

##
# Get list of remote or local GIT branches
# @param string $1 Directory to check
# @param int $2 Remote environment
# @return string
function __git_branch ()
{
    local dir="$1"
    if [[ -z "$dir" || ! -d "$dir" ]]; then
        return 0
    fi
    declare -i remote="$2"

    if [[ ${remote} -eq 1 ]]; then
        # Get only list of unique branches known on remote repository
        echo "$(cd "$dir" && git remote show origin | sed '/:/ d' | sed '/*/ d' | awk '{print $1}' | sort | uniq)"
    else
        # Get only local branches
        echo "$(cd "$dir" && git branch)"
    fi
}

##
# Print a progress bar
#
# @example
#    [++++++++++++++++----] 70%
#
# @param int $1 Step
# @param int $2 Max
# @return string
function __progress_bar ()
{
    declare -i step="$1"
    declare -i max="$2"
    if [[ ${max} -le 0 ]]; then
        return 0
    fi

    local charEmpty="-"
    local charFilled="+"
    declare -i width=20
    declare -i percent=0
    declare -i progress=0
    if [[ ${step} -gt 0 ]]; then
        percent=$((100*${step}/${max}))
        progress=$((${width}*${step}/${max}))
        if [[ ${progress} -gt ${width} ]]; then
            progress=${width}
        fi
    fi
    declare -i empty=$((${progress}-${width}))

    # Output to screen
    local strFilled=$(printf "%${progress}s" | tr " " "$charFilled")
    local strEmpty=$(printf "%${empty}s" | tr " " "$charEmpty")
    printf "\r[%s%s] %d%%" "$strFilled" "$strEmpty" "$percent"

    # Job done
    if [[ ${step} -ge ${max} ]]; then
        echo -e "\n"
    fi
}

##
# Search in path if branch exists in Git repositories
# @param string $1 Branch name
# @param string $2 Root of GIT repositories to check
# @param int $3 Local search if 1, remote search otherwise
# @return string
# @returnStatus 1 If brand name is empty
# @returnStatus 1 If root directory is unknown
# @returnStatus 2 If branch name is unknown in git repositories
function gitwib ()
{
    local branch="$1"
    local dir="$2"
    if [[ -z "$branch" || -z "$dir" || ! -d "$dir" ]]; then
        return 1
    fi
    declare -i remote="$3"

    # Number of GIT repository to check
    declare -i count=$(find "${dir%/}" -name ".git" -type d 2>/dev/null | wc -l)
    __progress_bar 0 ${count}

    # Check each repository
    local res rep
    declare -i nb=0
    while read -d '' -r repository; do
        if [[ -n "$(__git_branch "$repository" "$remote" | grep -E "\*?[[:space:]]?${branch}[[:space:]]?$")" ]]; then
           rep="${repository:${#dir}}"
           res+="Branch named ${GW_COLOR_BLUE}${branch}${GW_COLOR_OFF} was found in ${GW_COLOR_BLUE}${rep::${#rep}-4}${GW_COLOR_OFF}\n"
        fi
        nb+=1
        __progress_bar ${nb} ${count}
    done < <(find "${dir%/}" -name ".git" -type d -print0 2>/dev/null)

    if [[ -z "$res" ]]; then
        if [[ ${nb} -eq 0 ]]; then
            echo -e "No GIT repository to fetch in ${GW_COLOR_RED}${dir%/}${GW_COLOR_OFF}\n"
        elif [[ ${nb} -eq 1 ]]; then
            echo -e "Branch name ${GW_COLOR_RED}${branch}${GW_COLOR_OFF} was not found in ${nb} GIT repository\n"
        else
            echo -e "Branch name ${GW_COLOR_RED}${branch}${GW_COLOR_OFF} was not found in ${nb} GIT repositories\n"
        fi
        return 2
    else
        echo -e "$res"
    fi
}

# Script usage & check if git is availabled
if [[ $# -lt 1 ]]; then
    usage
    exit 1
elif [[ -z "$(type -p git)" ]]; then
    usage GIT
    exit 2
fi

# Read the options
# Use getopts vs getopt for MacOs portability
while getopts "b::d:l" FLAG; do
    case "${FLAG}" in
        b) branchName="$OPTARG" ;;
        d)
           if [[ "${OPTARG:0:1}" == "/" ]]; then
               wrkDir="$OPTARG";
           else
               wrkDir="${wrkDir}${OPTARG}"
           fi
           ;;
        l) remoteBranch=0 ;;
        *) usage; exit 1 ;;
        ?) exit 2 ;;
    esac
done
shift $(( OPTIND - 1 ));

# Mandatory options
if [ -z "$branchName" ]; then
    usage
    exit 1
fi

gitwib "$branchName" "$wrkDir" "$remoteBranch"
