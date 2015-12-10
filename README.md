# GitWib

GIT, where is my branch ?
Bash command line tools to search a branch by name in all local or remote GIT repositories

## Required

GIT command line tool

## Usage

By default, GitWib uses the current directory as root for all GIT repositories. To overload it, use -d option.
To use it in local environment only, use -l option.

Usage: gitwib -b branch_name [-d home_workspace] [-l]"
* -b Branch named to search
* -d Root directory with GIT repositories
* -l Used to keep in local

## Quick start

Launch `makefile.sh` in order to create alias `gitwib`.

```bash
$ ./makefile.sh
````

Then open a new shell terminal and make your first search:

```bash
$ gitwib -b "feature-42286"
Branch named feature-42286 was found in the repository /Users/hgouchet/Documents/my-project/.git
````

Enjoy!