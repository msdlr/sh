#!/bin/sh

repoDir='THEMES'
install='apt install'
repo='https://github.com/mbadolato/iTerm2-Color-Schemes.git'

[ $(command -v dmenu) ] || ( echo "Need to install dmenu"  ;  sudo $install dmenu)


# Clone or pull
[ -d ~/$repoDir ] && ( cd ~/$repoDir && git pull ) || ( rm -r ~/$repoDir ; mkdir ~/$repoDir && git clone $repo ~/$repoDir )

# Select terminal
cd ~/$repoDir
term=$( ls | sed '/LICENSE/d; /README.md/d; /backgrounds/d; /windowsterminal/d; /screenshots/d;' | dmenu -i -p "Which terminal?" )

# Select theme
cd ~/$repoDir/$term; 
theme=$( (ls | sed 's/\.[^.]*$//'  & echo "*") | dmenu -i -p "Theme? (or *)")

# Create theme folder if it doesn't exist
[ ! -d ~/.local/share/$term ] && mkdir -p ~/.local/share/$term

# Copy theme files
cp ./$theme* ~/.local/share/$term

# Remove themes directory?
remove=$(echo "No\nYes"  | dmenu -i -p "Remove themes repo?")
[ "$remove" = "Yes" ] && rm -r ~/$repoDir

exit
