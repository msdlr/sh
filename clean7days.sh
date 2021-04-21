#!/usr/bin/env/sh

# Selects downloads directory

[ -d  $HOME/Descargas ] && dir="$HOME/Descargas" 
[ -d  $HOME/Downloads ] && dir="$HOME/Downloads" 

# Otherwise, the parameter

[ -z "$1" ] || dir="$1"

# Remove files older than 7 days, or second parameter

[ -z "$2" ] && days="7" || days="$2"

# Find files and delete them (Not the directry itself)
cd $dir
files=`find . -mtime +$days | sed '/\.$/d'`

for file in $files
do
	rm -rf $file 2>/dev/null 
done

exit
