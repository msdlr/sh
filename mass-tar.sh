#!/usr/bin/env sh
[ ${#} -eq 0 ] && exit

which pigz >/dev/null && alias tar='tar -I pigz'

for file in ${@}
do
    cd $(dirname ${file})
    tar -cf $(basename ${file}).tgz $(basename ${file})
    rm -rf $(basename ${file})
done
