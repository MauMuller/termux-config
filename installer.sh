#!/bin/bash

set -e

error () {
	echo -e "\n \033[1m\033[31m[Error] $1\\033[0m\n"
}

scriptName="termux-config"

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

tagsURL="https://api.github.com/repos/MauMuller/termux-config/tags"
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
echo -e " https://api.github.com/repos/MauMuller/termux-config/tags"
echo -e "\n (default: latest)\n"
read -p " > " versionInstaller

if [ ! "$versionInstaller" ] || [[ "$versionInstaller" =~ LATEST|latest ]] 
	then versionInstaller="$(echo "$formatedVersions" | sed -E "s/\s|//gi" | head -n 1)"
fi

termuxConfigFile="$($httpTool "https://raw.githubusercontent.com/MauMuller/termux-config/refs/tags/$versionInstaller/termux-config.sh")"

echo -e "$termuxConfigFile" > "$scriptPath/$scriptName"
chmod a+x "$scriptPath/$scriptName"

echo -e "\n Do you like to configure PATH automatically for command line? [y|n]"
echo -e " (default: y)\n"
read -p " > " automaticResponse

if [ ! "$automaticResponse" ] 
	then automaticResponse="y"
fi

dirConfigPath="\$PATH:$scriptPath"

case "$automaticResponse" in
	n|N)
		echo -e "\n\033[1mManual Configuration\033[0m"
		echo -e "\n Add the following to your config file (Ex: .bashrc):"
		echo -e "\n\t[\033[3m.bashrc]\033[0m\n\texport \"\$PATH:$dirInstaller/.$scriptName\""
		echo -e "\n Reset environment configurations (Ex: .bashrc):"
		echo -e "\n\t\033[3m[shell]\033[0m\n\tsource .bashrc"
		;;
	y|Y)
		currentShell="$(echo $SHELL | sed -E "s/.*\///ig")"
		configPath=""

		case "$currentShell" in
			bash )
				configPath="$HOME/.bashrc"
				;;
			zsh )
				configPath="$HOME/.zshrc"
				;;
			fish )
				configPath="$HOME/.config/fish/config.fish"
				;;
			* )
				configPath="$HOME/.profile"
				;;
		esac

		export PATH="$dirConfigPath" >> "$configPath"
		echo -e "export PATH=\"$dirConfigPath\"" >> "$configPath"

		echo -e "\n\033[1mAutomatic Configuration\033[0m"
		echo -e "\n Config PATH found:"
		echo -e "\n\t$configPath"
		echo -e "\n Script added on config:"
		echo -e "\n\t[\033[3m$configPath]\033[0m\n\texport \"\$PATH:$scriptPath\""
		;;
	*)
		error "Invalid response."
		exit 1;
esac

echo -e "\n\033[1mFinal Step\033[0m"
echo -e "\n After followed configurations steps, everthing usually be ok."
echo -e " Now, just type by: \033[1m\033[93m$scriptName\\033[0m\n"
