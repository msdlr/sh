#!/bin/sh

repoDir='.termThemes'
install='apt install'
repo='https://github.com/mbadolato/iTerm2-Color-Schemes.git'
terminals="konsole\nxfce4terminal\nlxterminal"

[ $(command -v fzy) ] || ( echo "Need to install fzy"  ;  sudo $install fzy)


# Clone or pull; if it doesn't exist the repo is cloned; if an error happens the program exists
[ -d ~/$repoDir ] && ( cd ~/$repoDir && git pull ) || ( rm -rf ~/$repoDir && git clone $repo ~/$repoDir) || exit

# Select terminal
cd ~/$repoDir

clear
term=$( echo -n "$terminals" | fzy )

case $term in
	konsole)
		# Stablish copy directory and select theme
		copyDir="$HOME/.local/share/konsole"
		thList=$( ls ~/$repoDir/$term | sed '/~/d')
		clear
		theme=$( (echo "$thList" | sed 's/\.[^.]*$//'  & echo "*") | fzy -l `tput lines` -p "Theme? (or *)" | sed -e 's/\ /*/g' )
		echo "Installing $theme"
	
		# Create the themes folder if it doesn't exist
		if [ ! -d "$copyDir" ]; then
			mkdir -p $copyDir
		fi
		
		cp -v ~/$repoDir/$term/$theme.colorscheme $copyDir
		;;

	xfce4terminal)
		# Stablish copy directory and select theme
	
		copyDir="$HOME/.local/share/xfce4/terminal/colorschemes"
		thList=$( ls ~/$repoDir/$term/colorschemes | sed '/~/d')
		clear
		theme=$( (echo "$thList" | sed 's/\.[^.]*$//'  & echo "*") | fzy -l `tput lines` -p "Theme? (or *)" | sed -e 's/\ /*/g' )
		echo "Installing $theme"
		
		# Create the themes folder if it doesn't exist
		if [ ! -d "$copyDir" ]; then
			mkdir -p $copyDir
		fi
		
		cp -v ~/$repoDir/$term/colorschemes/$theme.theme  $copyDir
		;;

	lxterminal)
		thList=$( ls ~/$repoDir/$term | sed '/~/d')
		theme=$( (echo "$thList" | sed 's/\.[^.]*$//') | fzy -l `tput lines` -p "Theme? ($term)")
		clear
		echo "Installing $theme.conf"
	
		Theme=$(cat ~/$repoDir/$term/$theme.conf)
		
		# First part of the file without the color directives
		sed -e "/^palette_color/d ; /^.g_color/d ; /^color_preset/d ; s/\[shortcut\]/;THEME/g ; /;THEME/q " ~/.config/lxterminal/lxterminal.conf > lxt1

		# The last lines until [shortcut]
		tac ~/.config/lxterminal/lxterminal.conf | sed '/^\[shortcut\]$/q' > lxt3r
		tac lxt3r > lxt3

		# Join all the files together
		cat lxt1 ~/$repoDir/$term/$theme.conf lxt3 | sed '/^;Paste the following*/d' > ~/.config/lxterminal/lxterminal.conf 

		#Remove files created
		rm ltx1 ltx3 ltx3r
		;;
	*)
		echo "Not a terminal"
		exit
		;;
esac

exit

# Select theme

# Remove themes directory?
remove=$(echo "No\nYes"  | fzy -p "Remove themes repo?")
[ "$remove" = "Yes" ] && rm -rf ~/$repoDir

exit
