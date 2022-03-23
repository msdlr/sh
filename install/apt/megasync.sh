#!/usr/bin/env sh

wget https://mega.nz/linux/MEGAsync/xUbuntu_20.04/amd64/megasync-xUbuntu_20.04_amd64.deb &&
wget https://mega.nz/linux/MEGAsync/xUbuntu_18.04/amd64/dolphin-megasync-xUbuntu_18.04_amd64.deb &&
sudo apt install ./*megasync*deb -y &&
rm -v ./*megasync*deb
