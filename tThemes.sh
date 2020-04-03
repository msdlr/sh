#!/bin/sh

dir='THEMES'
install='apt install '
repo='https://github.com/mbadolato/iTerm2-Color-Schemes.git'

[ $(command -v dmenu) ] || ( echo "Need to install dmenu"  ;  sudo $install dmenu)


# Clone or pull
[ -d ~/$dir ] && ( cd ~/$dir && git pull ) || ( rm -r ~/$dir ; mkdir ~/$dir && git clone $repo ~/$dir )

# Select terminal
cd ~/$dir
term=$( ls | sed '/LICENSE/d; /README.md/d; /backgrounds/d; /windowsterminal/d; /screenshots/d;' | dmenu -i -p "Which terminal?" )

# Select theme
cd ~/$dir/$term; 
theme=$( (ls | sed 's/\.[^.]*$//'  & echo "*") | dmenu -i -p "Theme? (or *)")

# Create theme folder if it doesn't exist
[ ! -d ~/.local/share/$term ] && mkdir -p ~/.local/share/$term

# Copy theme files
cp ./$theme* ~/.local/share/$term

# Remove themes directory?
remove=$(echo "No\nYes"  | dmenu -i -p "Remove themes repo?")
[ "$remove" = "Yes" ] && rm -r ~/$dir

exit
