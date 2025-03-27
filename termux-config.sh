#!/bin/bash
name=$(echo $0 | sed -E "s/(^\.\\/)|(\.\w+$)//gm")

invalidCommand () {
	invalid=$1
	
	validCommand=$(if [ $2 ]; then echo $2; else echo "<command>"; fi)
	validOptions=$(if [ $3 ]; then echo $3; else echo "[options]"; fi)

	echo -e "\nUsage:"
	echo -e "  $name $validCommand $validOptions"

	echo -e "\nno such option: $invalid"
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
