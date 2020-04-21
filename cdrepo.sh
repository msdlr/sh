#!/bin/sh

clear
repodir=$(find . -name '.git' | sed 's|^\.\/||g  ; s|\/.git$||' | fzy -l `tput lines`)

# git status and files
cd $repodir
ls -l && git status  

# Execute shell on that directory

bash 
exit
