#!/usr/bin/env sh

flatpak_list=$(flatpak list | awk -F '\t' '{print $2}')

for dir in "$HOME/.var/app"/*/
do
    app_id=$(basename "$dir")
    if ! echo "$flatpak_list" | grep -q "^$app_id\$"
    then
        rm -rf "$dir"
        echo "Removed $dir"
    fi
done

