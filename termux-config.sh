#!/bin/bash
name="$(echo $0 | sed -E "s/(^\.\\/)|(\.\w+$)//gm")"
termuxFile="$(cat $HOME/.termux/termux.properties 2> /dev/null)"

separator () {
	echo ""
}

usage () {
	paramsList=($1 $2 $3)

	echo -e "Usage:"
	echo -e "  $name ${paramsList[@]}"
}

description () {
	echo -e "Description:"
	echo -e "  $1"
}

error () {
	invalid=$1

	echo -e "Error:"
	echo -e "  no such option: $invalid"
}

suggest () {
	paramsList=($1 $2 $3)

	echo -e "Suggest:"
	echo -e "  $name ${paramsList[@]} [-h|--help]"
}

commands () {
	echo -e "Commands:"
	list="$1"

	for (( i=0; i<${#list[@]}; i++ ))
	do
		name="$(echo ${list[i]} | sed -E 's/=.*//ig')"
		description="$(echo ${list[i]} | sed -E 's/.*=//ig')"
		
		echo -e "  $name\n$description" | pr -2 -at
	done
}

case $1 in
	"" | -h | --help )
		echo "help"
		;;

	show )
		case $2 in
			-h | --help )
				echo "termux-config show --help"
				;;

			-a | --all )
				file="$(cat $HOME/.termux/termux.properties 2> /dev/null)"

				if [[ $file ]]
					then echo -e "$file"
					else echo -e "\nNothing file was found.\n"
				fi
				;;

			"" )
				file="$(cat $HOME/.termux/termux.properties 2> /dev/null | grep -E '^[^#]')"
				if [[ $file ]]
					then echo -e "$file"
					else echo -e "\nNothing configurations was found.\n"
				fi
				;;
			* )
				usage $1 "[options]"
				error $2
				suggest $1
				;;
		esac
		;;

	get )
		;;
	change )
		;;
	* )
		usage "<commands>" "[options]"
		error $1
		suggest 
		;;
esac
