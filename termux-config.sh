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
		list=(
			'get=show one/all configuration(s)'
			'set=change configuration value'
		)

		separator
		usage "<command>"
		separator
		description "A command line to modify and seetermux configuration easier than manually."
		separator
		commands "$list"
		separator
		;;

	get )
		case $2 in
			-h | --help | "" )
				echo "termux-config show --help"
				;;

			-a | --all )
				file="$(cat $HOME/.termux/termux.properties 2> /dev/null)"

				if [[ $file ]]
					then echo -e "$file"
					else echo -e "\nNothing file was found.\n"
				fi


				if [[ $file ]]
					then echo -e "$file"
					else echo -e "\nNothing configurations was found.\n"
				fi
				;;

			* )
				foundKeyValue="$(echo "$termuxFile" | grep -E "^$2")"
				
				if [[ "$foundKeyValue" ]] && [[ "$2" ]]
					then 
						echo "$foundKeyValue"
						exit 1
				fi

				separator
				usage $1 "[options]"
				separator
				error $2
				separator
				suggest $1
				separator
				;;
		esac
		;;

	set )
		echo "set"
		;;
	* )
		separator
		usage "<commands>" "[options]"
		separator
		error $1
		separator
		suggest 
		separator
		;;
esac
