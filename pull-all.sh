#!/usr/bin/env sh

prefix="$HOME/src"

repos=$(find $prefix -type d -maxdepth 1 )

for r in $repos
do
	if [ -d $r/.git ]; then
		cd $r	
		git pull
	fi
done
