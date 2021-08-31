#!/usr/bin/env sh

PREFIX=/opt

[ -z "$1" ] &&  VERSION=$(curl -s https://golang.org/dl/ | grep src.tar.gz | head -n 1 | sed 's/^.*go//g; s/.src.tar.gz">//') || VERSION="$1"

# Get architecture
case $(uname -m) in
    i386)   ARCH="386" ;;
    i686)   ARCH="386" ;;
    x86_64) ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
esac

echo "Installing Go $VERSION ($ARCH)"

[ -f go$VERSION.linux-$ARCH.tar.gz ] ||  wget https://golang.org/dl/go$VERSION.linux-$ARCH.tar.gz 
sudo tar -C $PREFIX -xzf go$VERSION.linux-$ARCH.tar.gz
rm go$VERSION.linux-$ARCH.tar.gz
$PREFIX/go/bin/go version
exit
