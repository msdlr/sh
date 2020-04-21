#!/bin/sh

# Selects downloads directory

[ -d  $HOME/Descargas ] && dir="$HOME/Descargas" || 
[ -d  $HOME/Downloads ] && dir="$HOME/Downloads" 

# Otherwise, the parameter

[ -z "$1" ] && echo "no arg" || dir="$1"

# Remove files older than 7 days, or second parameter

[ -z "$2" ] && days="7" || days="$2"

	# echo "Cleanup: $dir, older than $days days"

rm -rf `find $dir -mtime +$days;`
exit
