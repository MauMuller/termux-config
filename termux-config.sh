#!/bin/bash
name=$(echo $0 | sed -E "s/(^\.\\/)|(\.\w+$)//gm")

invalidCommand () {
	invalid=$1
	paramsList=($2 $3 $4)

	echo -e "\nUsage:"
	echo -e "  $name ${paramsList[@]} $invalid"

	echo -e "\nError:"
	echo -e "  no such option: $invalid"

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
			off )
				echo "set"
				;;

			"" )
				file=$(cat $HOME/.termux/termux.properties 2> /dev/null | grep -E '^[^#]')
				if [[ $file ]]
					then echo -e $file
					else echo -e "\nNothing configurations was found.\n"
				fi
				;;
			* )
				invalidCommand $2 "visibilitty"
				;;
		esac
		;;

	get )
		;;
	change )
		;;
	* )
		invalidCommand $1
		;;
esac
