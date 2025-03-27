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
	"" | --help | -h )
		echo "help"
		;;

	visibility )
		case $2 in
			on )
				echo "get"
				;;
			off )
				echo "set"
				;;

			"" )
				echo "help visibility"
				;;
			* )
				invalidCommand $2 "visibilitty"
				;;
		esac
		;;

	* )
		invalidCommand $1
		;;
esac
