# GitWib

GIT, where is my branch ?
Bash command line tools to search a branch by name in all local or remote GIT repositories

## Required

GIT command line tool

## Usage

Usage: ${SCRIPT} -b branch_name [-d home_workspace] [-l]"
* -b Branch named to search
* -d Root directory with GIT repositories
* -l used keep in local search

## Quick start

Launch `makefile.sh` in order to create alias `gitwib` and open a new shell terminal.

```bash
$ ./makefile.sh
````

Then, make your first search:

```bash
$ gitwib -b "feature-42286"
Branch named feature-42286 was found in the repository /Users/hgouchet/Documents/my-project/.git
````

Enjoy!