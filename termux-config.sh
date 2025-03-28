#!/bin/bash
name=$(echo $0 | sed -E "s/(^\.\\/)|(\.\w+$)//gm")

usage () {
	paramsList=($1 $2 $3)

	echo -e "\nUsage:"
	echo -e "  $name ${paramsList[@]}"
}

error () {
	invalid=$1

	echo -e "\nError:"
	echo -e "  no such option: $invalid"
}

suggest () {
	paramsList=($1 $2 $3)

	echo -e "\nSuggest:"
	echo -e "  $name ${paramsList[@]} [-h|--help]\n"
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
