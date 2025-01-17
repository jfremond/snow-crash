#!/bin/sh

# BOLD='\e[1m'
# RED='\e[31m'
# RESET='\e[0m'
# ERROR=$BOLD$RED'error'$RESET

# if [ $# -ne 1 ]; then
# 	echo "$ERROR: wrong number of arguments"
# 	echo 'usage: make_every_owned_directory_explorable.sh DIRECTORY'
# 	exit 1
# fi

add_missing_perms_on_owned_dirs_in() {
	# DIRECTORY=$1
	for perm in r x; do
		find $DIRECTORY -maxdepth 1 -type d -user $USER ! -perm /u+$perm -exec chmod u+$perm '{}' +
	done

	for dir in $(find $DIRECTORY -mindepth 1 -maxdepth 1 -type d); do
		DIRECTORY=$dir
		add_missing_perms_on_owned_dirs_in
	done
}

DIRECTORY='/'
add_missing_perms_on_owned_dirs_in # $1

exit 0
