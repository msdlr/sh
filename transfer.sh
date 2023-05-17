#!/usr/bin/env sh

ddrive=/mnt/d

. ~/.config/user-dirs.dirs

if [ "$(id -u)" -ne "0" ]
then 
	rm -r $XDG_PICTURES_DIR
	ln -sv $ddrive/IMG $XDG_PICTURES_DIR
	
	rm -r $XDG_VIDEOS_DIR
	ln -sv $ddrive/VID $XDG_VIDEOS_DIR
	
	rm -r $XDG_DOCUMENTS_DIR
	ln -sv $ddrive/DOC $XDG_DOCUMENTS_DIR
	
	rm -r $XDG_DOWNLOAD_DIR
	ln -sv $ddrive/DL $XDG_DOWNLOAD_DIR
	
	rm -r $XDG_MUSIC_DIR
	ln -sv $ddrive/MU $XDG_MUSIC_DIR
fi
exit
