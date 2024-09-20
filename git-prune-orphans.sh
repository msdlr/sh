#!/usr/bin/env sh

# Exit if not on a git repo
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1
then
    echo "This is not a Git repository."
    exit
fi

remote_name=origin
remote_branches=$(mktemp); git branch -r | sed "s|${remote_name}/||; /HEAD/d; s| ||g" | sort > $remote_branches
local_branches=$(mktemp); git branch | sed "s|\*||; s| ||g" | sort > $local_branches
branches_not_in_remote=$(comm -23 ${local_branches} ${remote_branches})
remote_branches_not_in_local=$(comm -23 ${remote_branches} ${local_branches})

rm ${local_branches} ${remote_branches}

if [ ! -z "$branches_not_in_remote" ]
then
    echo "Orphan LOCAL branches (not in remote $remote_name)"
    for b in $branches_not_in_remote
    do
        printf "> Do you want to delete orphan branch '%s'? (y/n): " "$b"
        read confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            printf "\e[32m"
            git branch -D $b
            printf "\e[39m"
        fi
    done
else 
    echo "All local branches are in remote $remote_name"
fi

if [ ! -z "$remote_branches_not_in_local" ]
then
    echo "Orphan REMOTE branches (only in remote $remote_name)"
    for b in $remote_branches_not_in_local
    do
        printf "> Do you want to delete remote orphan branch ${remote_name}/'%s'? (y/n): " "$b"
        read confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            printf "\e[32m"
            git push -d ${remote_name} $b
            printf "\e[39m"
        fi
    done
else
    echo "All branches in remote $remote_name are in local"
fi