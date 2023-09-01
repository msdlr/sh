#!/usr/bin/env sh

# Selects downloads directory
. ~/.config/user-dirs.dirs

dirs="${XDG_DOWNLOAD_DIR} ${XDG_CACHE_DIR}"

[ -z "$dirs" ] && [ -z "$1" ] && exit

# Otherwise, the parameter

[ -z "$1" ] || dir="$1"

# Remove files older than 7 days, or second parameter

[ -z "$2" ] && days="7" || days="$2"

for dir in $dirs
do
	# Find files and delete them (Not the directry itself)
	find ${dir}/ -type f -mtime +${days} -delete
	find ${dir}/ -mindepth 1 -depth -type d -empty -delete
	find ${dir}/ -type l -xtype l -exec rm {} + # Broken symlinks
done

exit
