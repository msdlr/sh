#!/usr/bin/env sh

# Selects downloads directory
[ -f ${HOME}/.config/user-dirs.dirs ] && . ${HOME}/.config/user-dirs.dirs

dirs="${XDG_DOWNLOAD_DIR}
${XDG_CACHE_DIR}
/storage/emulated/0/Download
/storage/emulated/0/DCIM
${HOME}/.var/app/org.telegram.desktop/data/TelegramDesktop/tdata/temp_data/
${HOME}/.var/app/org.kde.kasts/data/KDE/kasts/enclosures"

[ -z "$dirs" ] && [ -z "$1" ] && exit

# Otherwise, the parameter

[ -z "$1" ] || dir="$1"

# Remove files older than 7 days, or second parameter

[ -z "$2" ] && days="7" || days="$2"

for dir in $dirs
do
	if [ -d "$dir" ]
	then
		# Step 1: Remove files older than 7 days
		find ${dir}/ -mindepth 1 -type f -mtime +${days} -exec rm -v {} \;
		# Step 2: Remove all symlinks
		find ${dir}/ -mindepth 1 -type l -exec rm -v {} \;
		# Step 3: Delete empty folders recursively
		find ${dir}/ -mindepth 1 -depth -type d  -empty -exec rmdir -v {} \;
		# Notify when done
		[ "$(command -v notify-send)" ] && notify-send "${dir} cleanup" "Remove files older than ${days} days"
	fi
done

exit
