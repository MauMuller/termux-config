#!/bin/bash
set -e

error () {
	echo -e "\n \033[1m\033[31m[Error] $1\\033[0m\n"
}

scriptName="termux-config"
user="MauMuller"
repo="$scriptName"

clear

echo -e "\n\033[1mInstallation\033[0m"
echo -e "\n Choose a directory for installation:"
echo -e " (default: ~/)\n"
read -p " > " dirInstaller

if [ ! "$dirInstaller" ] 
	then dirInstaller="$HOME"
fi

scriptPath="$dirInstaller/.$scriptName/bin"
makeDirectory=$(mkdir -p "$scriptPath" 2>&1)

if [ "$makeDirectory" ]
	then 
		error "$makeDirectory"
		exit 1;
fi

if [ ! -d "$dirInstaller" ]
	then 
		error "Isnt a valid directory."
		exit 1;
fi

tagsURL="https://api.github.com/repos/$user/$repo/tags"
httpTool=$(if [ "type -t curl 2>&1" ]; then echo 'curl'; else echo 'wget'; fi)
rawVersions=""

case "$httpTool" in
	curl)
		rawVersions=$(curl -fsL --show-error "$tagsURL")
		;;
	wget)
		rawVersions=$(wget -q --content-on-error -O - "$tagsURL")
		;;
esac

formatedVersions=$(echo "$rawVersions" | grep -E "name" | sed -E "s/\s|,|\"//gi" | sed -E "s/name?:/ /gi")

echo -e "\n\033[1mVersion\033[0m"
echo -e "\n Choose a version to install:"
echo -e "$(echo "$formatedVersions" | head | pr -2 -at -w 95)"
echo -e "\n For others, see the following link:"
echo -e " $tagsURL"
echo -e "\n (default: latest)\n"
read -p " > " versionInstaller

if [ ! "$versionInstaller" ] || [[ "$versionInstaller" =~ LATEST|latest ]] 
	then versionInstaller="$(echo "$formatedVersions" | sed -E "s/\s|//gi" | head -n 1)"
fi

termuxConfigURL="https://raw.githubusercontent.com/$user/$repo/refs/tags/$versionInstaller/$scriptName.sh"
termuxConfigContent=""

case "$httpTool" in
	curl)
		termuxConfigContent=$(curl -fsL --show-error "$termuxConfigURL")
		;;
	wget)
		termuxConfigContent=$(wget -q --content-on-error -O - "$termuxConfigURL")
		;;
esac

echo -e "$termuxConfigContent" > "$scriptPath/$scriptName"
chmod a+x "$scriptPath/$scriptName"

echo -e "\n\033[1mConfiguration\033[0m"
echo -e "\n \033[2mObservation\033[0m:\n"
echo -e "   This exemple use \033[4m.bashrc\033[0m to ilustrate the steps."
echo -e "   But you can use any other like: .zshrc, .config/fish/fish.config, etc."
echo -e "\n \033[2mSteps\033[0m"
echo -e "\n   1. Add the following to your config file:"
echo -e "\n\t export PATH=\"\$PATH:$dirInstaller/.$scriptName/bin\""
echo -e "\n   2. Reset environment configurations:"
echo -e "\n\t source \$HOME/.bashrc"

echo -e "\n\033[1mFinal Step\033[0m"
echo -e " Now, just type by: \033[1m\033[93m$scriptName\\033[0m\n"
