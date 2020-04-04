#!/bin/sh

repoDir='THEMES'
install='apt install'
repo='https://github.com/mbadolato/iTerm2-Color-Schemes.git'
terminals='konsole\nxfce4terminal\nlxterminal'


#sed '/^palette_color/d ; /^.g_color/d ; /^color_preset/d ; s/\[shortcut\]/ASD\n\[shortcut\]/g ' .config/lxterminal/lxterminal.conf


[ $(command -v dmenu) ] || ( echo "Need to install dmenu"  ;  sudo $install dmenu)


# Clone or pull; if it doesn't exist the repo is cloned; if an error happens clone is reattempted; otherwise the program exists
[ -d ~/$repoDir ] && ( cd ~/$repoDir && git pull ) || ( git clone $repo ~/$repoDir || rm -rf ~/$repoDir && git clone $repo ~/$repoDir) || exit

# Select terminal
cd ~/$repoDir
#term=$( ls | sed '/LICENSE/d; /README.md/d; /backgrounds/d; /windowsterminal/d; /screenshots/d;' | dmenu -i -p "Which terminal?" )

term=$( echo $terminals | dmenu )

case $term in
	konsole)
		# Stablish copy directory and select theme
		copyDir="$HOME/.local/share/konsole"
		thList=$( ls ~/$repoDir/$term | sed '/~/d')
		theme=$( (echo "$thList" | sed 's/\.[^.]*$//'  & echo "*") | dmenu -i -p "Theme? (or *)" | sed -e 's/\ /*/g' )
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
		theme=$( (echo "$thList" | sed 's/\.[^.]*$//'  & echo "*") | dmenu -i -p "Theme? (or *)" | sed -e 's/\ /*/g' )
		echo "Installing $theme"
		
		# Create the themes folder if it doesn't exist
		if [ ! -d "$copyDir" ]; then
			mkdir -p $copyDir
		fi
		
		cp -v ~/$repoDir/$term/colorschemes/$theme.theme  $copyDir
		;;

	lxterminal)
		thList=$( ls ~/$repoDir/$term | sed '/~/d')
		theme=$( (echo "$thList" | sed 's/\.[^.]*$//') | dmenu -i -p "Theme? ($term)")
		echo "Installing $theme.conf"
	
		Theme=$(cat ~/$repoDir/$term/$theme.conf)

		echo "$Theme" | less

		sed '/^palette_color/d ; /^.g_color/d ; /^color_preset/d ; s/\[shortcut\]/ASD\n\[shortcut\]/g ' .config/lxterminal/lxterminal.conf
		
		;;
	*)
		echo "error"
		exit
		;;
esac

exit

# Select theme

# Remove themes directory?
remove=$(echo "No\nYes"  | dmenu -i -p "Remove themes repo?")
[ "$remove" = "Yes" ] && rm -rf ~/$repoDir

exit
