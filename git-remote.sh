#!/usr/bin/env sh

switch_to_https () {
	echo "Switching remote(s) to https" 
	
	for l in ${lines_with_urls}
	do
		sed -i "${l}s|:|/| ; ${l}s|git@|https://|" .git/config
		
		# in case https:// gets replaced by https//
		sed -i "s|///|://|g" .git/config
	done

	grep "url" .git/config
}

switch_to_ssh () {
	echo "Switching remote(s) to git" 
	
	for l in ${lines_with_urls}
	do
		sed -i "s|https://|git@| ; ${l}s|/|:|" .git/config 
	done
	
	grep "url" .git/config
}

lines_with_urls=$(grep -n "url" .git/config | cut -f1 | sed 's/://g')

[ -z "${1}" ] && echo "https/ssh" && exit


case ${1} in
	"https")
		switch_to_https
		;;
	"ssh")
		switch_to_ssh
		;;
	*)
		echo "???"
		;;
esac
