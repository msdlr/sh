#!/usr/bin/env sh

prefix="$HOME/src"

repos=$(find $prefix -maxdepth 1 -type d)

for r in $repos
do
	if [ -d $r/.git ]; then
		cd $r	
		timeout 600 git pull &
	fi
done
