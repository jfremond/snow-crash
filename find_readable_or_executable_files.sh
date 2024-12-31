#!/bin/sh

BOLD='\e[1m'
RED='\e[31m'
RESET='\e[0m'
ERROR=$BOLD$RED'error'$RESET

if [ $# -ne 1 ]; then
	echo "$ERROR: wrong number of arguments"
	echo 'usage: find_every_file_that_can_be_run_or_read.sh DIRECTORY'
	exit 1
fi

USER_SHARES_A_GROUP_WITH_FILE=$(
	for gid in $(id -G); do
		echo -n " -or -group $gid"
	done | sed "s/^ -or //"
)

# Finds every file that satisfies at least one of the following conditions:
# - the user owns the file
# - the user shares a group with the file AND at least one of the following conditions is true:
#   - the file is group-readable
#   - the file is group-executable
# - the file is other-readable
# - the file is other-executable
find $1 -type f \( -user $USER -or \( \( $USER_SHARES_A_GROUP_WITH_FILE \) -perm /g+rx \) -or -perm /o+rx \) 2>/dev/null

exit 0
