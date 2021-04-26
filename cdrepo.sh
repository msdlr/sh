#!/usr/bin/env sh

 which fzy >/dev/null || exit

clear
repodir=$( locate $(pwd)*.git | sed 's/\/.git//' | fzy -l `tput lines`)

# git status and files
cd $repodir
ls -l && git status  

# Execute shell on that directory

bash 
exit
