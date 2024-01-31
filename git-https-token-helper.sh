#!/bin/sh

# Prompt user for Git repository URL
printf "Enter Git repository URL (example: https://github.com or https://github.com/user/repo): "
read git_url

# Prompt user for access token
printf "Enter Git access token: "
# stty -echo
read git_token
# stty echo
printf "\n"

# Determine the Git URL based on the input
if echo "$git_url" | grep -q "^https://"; then
  # URL starts with "https://", replace it with "https://git:$git_token"
  new_git_url="https://git:$git_token${git_url#https://}"
else
  # URL does not start with "https://", prepend "https://git:$git_token@"
  new_git_url="https://git:$git_token@$git_url"
fi

if ! echo "$git_url" | grep -q "^https://"; then
  git_url="https://$git_url"
fi

# Display the modified Git URL
echo "$git_url -> $new_git_url" 

# Set the Git configuration
export new_git_url
export git_url
sh -xc 'git config --global url."$new_git_url".insteadOf "$git_url"'
