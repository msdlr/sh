#!/bin/sh

repoDir='THEMES'
install='apt install'
repo='https://github.com/mbadolato/iTerm2-Color-Schemes.git'

[ $(command -v dmenu) ] || ( echo "Need to install dmenu"  ;  sudo $install dmenu)


# Clone or pull; if it doesn't exist the repo is cloned; if an error happens clone is reattempted; otherwise the program exists
[ -d ~/$repoDir ] && ( cd ~/$repoDir && git pull ) || ( git clone $repo ~/$repoDir || rm -rf ~/$repoDir && git clone $repo ~/$repoDir) || exit

# Select terminal
cd ~/$repoDir
term=$( ls | sed '/LICENSE/d; /README.md/d; /backgrounds/d; /windowsterminal/d; /screenshots/d;' | dmenu -i -p "Which terminal?" )

# Select theme
cd ~/$repoDir/$term; 
theme=$( (ls | sed 's/\.[^.]*$//'  & echo "*") | dmenu -i -p "Theme? (or *)")

# Create theme folder if it doesn't exist
[ ! -d ~/.local/share/$term ] && mkdir -p ~/.local/share/$term

# Copy theme files in .local/share
cp ./$theme* ~/.local/share/$term

# Remove themes directory?
remove=$(echo "No\nYes"  | dmenu -i -p "Remove themes repo?")
[ "$remove" = "Yes" ] && rm -rf ~/$repoDir

exit
