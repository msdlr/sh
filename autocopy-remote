#!/bin/env sh

# Track changes in local repos and updates remote copies
# Use: $0 remote_user remote_server local_dir 

# Minimum parameter check
[ $# -lt 3 ] && echo "Use: $0 remote_user remote_server local_dir" && return


USER_REMOTE=$1
DEST=$2
LOCAL_DIR=$3

# Remove trailing '/' from autocompletion
LOCAL_DIR=$(echo ${LOCAL_DIR} | sed 's|/$||')
PATH_REMOTE=$(dirname $(echo ${LOCAL_DIR} | sed "s/${USER}/${USER_REMOTE}/g"))

if [ $(expr "$(uname --kernel-release)" : ".*WSL.*") != "0" ]
then
	notify='wsl-notify-send.exe --appId "autocopy-remote" --category'
fi

notify=${notify:='notify-send'}

# Depedency check
exit=""

for dep in rsync entr
do
    if [ "$(which ${dep})" = "" ]
    then
        echo "${dep} missing"
        exit=return
    fi
done

# Exit if dependencies not satisfied
$exit

ssh ${USER_REMOTE}@${DEST} [ -d ${PATH_REMOTE} ] || ssh ${USER_REMOTE}@${DEST} mkdir -pv ${PATH_REMOTE}

while [ "1" = "1" ];
do
	find ${LOCAL_DIR} | entr sh -c "rsync -rv ${LOCAL_DIR} ${DEST}:${PATH_REMOTE} && $notify \"Autocopy\" \"$(basename ${LOCAL_DIR}) -> ${DEST}:${PATH_REMOTE}\""
done
