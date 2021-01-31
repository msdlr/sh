#!/bin/sh

missing=$(go build 2>/dev/stdout | grep "cannot find" | awk '{print $5}' | sed -e 's/"//g')

cd $GOPATH
echo "In GOPATH dir: $GOPATH"

for package in $missing
do
	echo "Installing $package in $(pwd)..."
	go get -v $package
done
