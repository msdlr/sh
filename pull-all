#!/usr/bin/env sh

prefix="$HOME/src"

repos=$(find $prefix -maxdepth 1 -type d)

for r in $repos
do
	if [ -d $r/.git ]; then
		cd $r	
		git submodule init
		timeout 60 git pull --recurse-submodules & 
	fi
done
wait
