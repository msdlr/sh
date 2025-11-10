#!/bin/sh
root="$HOME/tex"
metarepo="$HOME/tex-git"

mkdir -pv "$metarepo"
cd $metarepo
git init .

for git_config in $(find ~/tex -wholename '*/.git/config'); do
    git_url=$(grep "url =" "$git_config" | sed 's|.*= ||')

    # Leave this repo as relative to create subdirectories
    sub_dir=$(dirname "$(dirname "$git_config")" | sed "s|$root/||g")

    mkdir -pv $(dirname "$sub_dir") 2>/dev/null
    git submodule add "$git_url" "$sub_dir" &
done
wait