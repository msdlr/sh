#!/bin/sh

# Track changes in local repos and updates remote copies
# Use: $0 remote_user remote_server local_dir 

USER_REMOTE=$1
DEST=$2
LOCAL_DIR=$3

# Remove trailing '/' from autocompletion
LOCAL_DIR=$(echo ${LOCAL_DIR} | sed 's|/$||')
PATH_REMOTE=$(dirname $(echo ${LOCAL_DIR} | sed "s/${USER}/${USER_REMOTE}/g"))

if [ $(( $(expr "$(uname --kernel-release)" : ".*WSL.*") )) ]
then
	notify='wsl-notify-send.exe --category'
fi

notify=${notify:='notify-send'}

# Dependencies: entr, rsync
inst='sudo apt install -y'
which entr >/dev/null || $inst install entr
which rsync >/dev/null || $inst install rsync

ssh ${USER_REMOTE}@${DEST} [ -d ${PATH_REMOTE} ] || ssh ${USER_REMOTE}@${DEST} mkdir -pv ${PATH_REMOTE}

while [ "1" = "1" ];
do
	find ${LOCAL_DIR} | entr sh -c "rsync -rv --delete ${LOCAL_DIR} ${DEST}:${PATH_REMOTE} && $notify \"Autocopy\" \"$(basename ${LOCAL_DIR}) -> ${PATH_REMOTE}@${DEST}\""
done
