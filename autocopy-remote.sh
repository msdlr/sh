#!/bin/sh

# Trackea cambios en un repo local y lo copia en cellia por scp
# Uso: $0 user_cellia repo_local

# Valores por defecto
USER_REMOTE=$USER
LOCAL_REPO=/path/to/repo
DEST=server

[ ! -z $1 ] && USER_REMOTE=$1
[ ! -z $2 ] && DEST=$2
[ ! -z $3 ] && LOCAL_REPO=$3
PATH_REMOTE=$(echo $LOCAL_REPO | sed "s/$USER/$USER_REMOTE/g")

# Dependencias: entr, rsync
which entr || sudo apt install entr -y 
which rsync || sudo apt install rsync -y 

echo "$USER -> $USER_REMOTE ($PATH_REMOTE)"

ssh $USER_REMOTE@$DEST [ -d $PATH_REMOTE ] || ssh $USER_REMOTE@$DEST mkdir -pv $PATH_REMOTE

while [ "1" = "1" ];
do
	ls $LOCAL_REPO/* | entr rsync -rv $LOCAL_REPO $DEST:$PATH_REMOTE
done
