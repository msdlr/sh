#!/usr/bin/env sh
[ ${#} -eq 0 ] && exit

alias compress='tar -zcf'
which pigz >/dev/null && alias compress='tar -I pigz -cf'

for f in ${@}
do
	file=$(realpath ${f})	   
	
	if [ -d ${file} ]; then
		cd $(dirname ${file})
		compress $(basename ${file}).tgz $(basename ${file})
	fi

	if [ -f ${file} ]; then
		compress $(basename ${file}).tgz -C $(dirname ${file}) $(basename ${file})
	fi
		#cd $(dirname ${file})
		#tar -cf $(basename ${file}).tgz $(basename ${file})
		#rm -rf $(basename ${file})
done
