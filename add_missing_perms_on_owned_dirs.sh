#!/bin/sh

BOLD='\e[1m'
RED='\e[31m'
RESET='\e[0m'
ERROR=$BOLD$RED'error'$RESET

if [ $# -ne 1 ]; then
	echo "$ERROR: wrong number of arguments"
	echo 'usage: make_every_owned_directory_explorable.sh DIRECTORY'
	exit 1
fi

add_missing_perms_on_owned_dirs_in() {
	for perm in r x; do
		find $1 -maxdepth 1 -type d -user $USER ! -perm /u+$perm -exec chmod u+$perm '{}' +
	done

	for dir in $(find $1 -mindepth 1 -maxdepth 1 -type d); do
		add_missing_perms_on_owned_dirs_in $dir
	done
}

add_missing_perms_on_owned_dirs_in $1

exit 0
