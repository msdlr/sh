#!/bin/sh

[ -z "$1" ] &&  VERSION="1.15.3" || VERSION="$1"

[ -f go$VERSION.linux-amd64.tar.gz ] ||  wget https://golang.org/dl/go$VERSION.linux-amd64.tar.gz 
sudo tar -C /usr/local -xzf go$VERSION.linux-amd64.tar.gz
rm -v go$VERSION.linux-amd64.tar.gz
/usr/local/go/bin/go version
exit
