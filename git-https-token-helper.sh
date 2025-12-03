#!/bin/sh

# git_url=${git_url:="https://git@example.org"}
# git_token=${git_token:="token"}
git_user=${git_user:="git"}

# Use existing value if already set, otherwise prompt user
if [ -z "$git_url" ]; then
  printf "Enter Git repository URL (example: https://github.com or https://github.com/user/repo or git@github.com:user/repo.git): "
  read git_url
fi

if [ -z "$git_token" ]; then
  printf "Enter Git access token: "
  # stty -echo
  read git_token
  # stty echo
  printf "\n"
fi

# Case 1: SSH-style git@...
if echo "$git_url" | grep -q "git@"; then
  git_url=$(echo "$git_url" | sed -E 's|git@||; s|https://||')

  new_git_url="https://${git_user}:${git_token}@${git_url}"

  git_url="https://""$git_url"

# Case 2: HTTPS URL
elif echo "$git_url" | grep -q "^https://"; then
  new_git_url="https://${git_user}:$git_token@${git_url#https://}"

# Case 3: No scheme
else
  git_url="https://$git_url"
  new_git_url="https://${git_user}:$git_token@${git_url#https://}"
fi

# Display the modified Git URL
echo "$git_url -> $new_git_url" 

# Set the Git configuration
export new_git_url
export git_url
sh -xc 'git config --global url."$new_git_url".insteadOf "$git_url"'
