#!/bin/sh

ddrive=/mnt/d

if [ "$(id -u)" -ne "0" ]
then 
	IMG=$HOME/Imágenes
	rm -rv $IMG && 
	ln -s $ddrive/IMG $IMG
	
	VID=$HOME/Vídeos
	rm -rv $VID && 
	ln -s $ddrive/VID $VID
	
	DOC=$HOME/Documentos
	rm -rv $DOC && 
	ln -s $ddrive/DOC $DOC
	
	DL=$HOME/Descargas
	rm -rv $DL && 
	ln -s $ddrive/DL $DL
	
	MU=$HOME/Música
	rm -rv $MU && 
	ln -s $ddrive/MU $MU
fi
exit
