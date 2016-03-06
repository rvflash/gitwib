# GitWib

GIT, where is my branch ?
Bash command line tool to search a branch by name in all local or remote GIT repositories


## Usage

By default, GitWib uses the current directory as root for all GIT repositories. To overload it, use -d option.
To use it in local environment only, use -l option.

```bash
usage: gitwib -b branch [-d rootDirectory] [-l]
-b Branch named to search
-d Root directory with GIT repositories to explore
-l used to keep in local search
```


## Quick start

Launch `makefile.sh` in order to create the alias `gitwib`.

```bash
~ $ git clone https://github.com/rvflash/gitwib
~ $ cd gitwib
~ $ ./makefile.sh
```

Then open a new shell terminal and make your first search !

```bash
~ $ gitwib  -b master -l
~ [++++++++++++++++++++] 100%
~ 
~ Branch named master was found in /awql-docs/
~ Branch named master was found in /bash-packages/
~ Branch named master was found in /gitwib/
```


## Required

GIT command line tool

Enjoy!