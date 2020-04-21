#!/bin/sh

clear
repodir=$(find . -name '.git' | sed 's|^\.\/||g  ; s|\/.git$||' | fzy -l `tput lines`)

# git status and files
cd $repodir
git status && ls -l 

# Execute shell on that directory
`echo $0`
exit
