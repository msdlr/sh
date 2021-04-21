#!/usr/bin/env/sh

# Remove spaces in filenames
find -name "* *" -type d | rename 's/ //g'

dirs=$(ls -d */ | sort | sed -e 's|\/||g')

for dirn in $dirs;
do
	tar -czvf $dirn.cbt $dirn/* &
done
exit
