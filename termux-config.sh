#!/bin/bash
cliName="$(echo $0 | sed -E "s/(^\.\\/)|(\.\w+$)//gm")"

termuxFileDir="$HOME/.termux/termux.properties"
termuxFile="$(cat "$termuxFileDir" 2> /dev/null)"

separator () {
	echo ""
}

usage () {
	paramsList=($1 $2 $3)

	echo -e "Usage:"
	echo -e "  $cliName ${paramsList[@]}"
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
	echo -e "  $cliName ${paramsList[@]} [-h|--help]"
}

exemples () {
	list="$1"

	echo -e "Exemples:"

	for (( i=0; i<${#list[@]}; i++ ))
	do
		exemple="${list[$i]}"
		echo -e "  $exemple"
	done
}

tableList () {
	nameSection="$1"
	list="$2"

	echo -e "$nameSection:"

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
			'show-all=show all configurations'
			'get=get key=value configuration'
			'set=change configuration value'
		)

		separator
		usage "<command>"
		separator
		description "A command line to modify and seetermux configuration easier than manually."
		separator
		tableList "Commands" "$list"
		separator
		;;

	show-all )
		case $2 in
			"" )
				echo "$(echo -e "$termuxFile" | grep -E '^[^#]')"
				;;
			-c | --comment )
				echo "$termuxFile"
				;;
			-h | --help )
				list=(
					'-c --comment=show commented (#) options.'
				)

				separator
				usage "$1" "[options]"
				separator
				description "Show all configurations from file"
				separator
				tableList "Options list" "$list"
				separator
				;;
			* )
				list=(
					'-c --comment=show commented (#) options.'
				)

				separator
				usage "$1" "[options]"
				separator
				error "$2"
				separator
				tableList "Options list" "$list"
				separator
				;;
		esac
		;;

	get )
		case $2 in
			-h | --help | "" )
				list=(
					'-c --comment=show commented (#) options.'
				)

				separator
				usage "$1" "(key) | [options]"
				separator
				description "Show current (key=value) from termux's configuration file."
				separator
				tableList "Options list" "$list"
				separator
				;;

			* )
				regexChecker=""

				if [ "$3" = "-c" ] || [ "$3" = "--comment" ]
					then regexChecker="^#?$2"
					else regexChecker="^$2"
				fi

				foundKeyValue="$(echo "$termuxFile" | grep -E "$regexChecker")"

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
		case $2 in
			-h | --help | "" )
				list=(
					"$cliName set extra-keys=[[{ key: RIGHT, popup: END }]]"
					"$cliName set back-key=back"
				)

				separator
				usage "$1" "(key=value)"
				separator
				description "Set value at termux's configuration file."
				separator
				exemples "$list"
				separator
				;;
			* )
				isValidFormat="$(echo $2 | grep -E "^\S+=\S+$")"

				if [ ! $isValidFormat ]
					then 
						separator
						usage $1 "(key=value)"
						separator
						error $2
						separator
						suggest $1
						separator
						exit
				fi

				key="$(echo "$2" | sed -E "s/=.+//gi")"
				value="$(echo "$2" | sed -E "s/.+=//gi")"

				doesPropertyExist="$(echo "$termuxFile" | grep -E "^$key")"

				if [ "$doesPropertyExist" ]
					then
						echo "$(echo "$termuxFile" | sed -E "s/$key\s?=\s?.+/$key = $value/gi")" > "$termuxFileDir"
					else 
						echo -e "\n$key = $value" >> "$termuxFileDir"

				fi
		esac
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
