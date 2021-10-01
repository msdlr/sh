#!/bin/sh

# Trackea changes in local repos and updates remote copies
# Uso: $0 remote_user local_dir 

# Valores por defecto
USER_REMOTE=$USER
LOCAL_DIR=/path/to/repo/
DEST=server

[ ! -z $1 ] && USER_REMOTE=$1
[ ! -z $2 ] && DEST=$2
[ ! -z $3 ] && LOCAL_DIR=$3

# Remove trailing '/' from autocompletion
LOCAL_DIR=$(echo $LOCAL_DIR | sed 's|/$||')

PATH_REMOTE=$(basename $(echo $LOCAL_DIR | sed "s/$USER/$USER_REMOTE/g"))

# Dependencies: entr, rsync
inst='sudo apt install -y'
which entr || $inst install entr
which rsync || $inst install rsync

ssh $USER_REMOTE@$DEST [ -d $PATH_REMOTE ] || ssh $USER_REMOTE@$DEST mkdir -pv $PATH_REMOTE

while [ "1" = "1" ];
do
	find $LOCAL_DIR | entr rsync -rv $LOCAL_DIR $DEST:$PATH_REMOTE
	exit
done
