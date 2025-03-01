#!/bin/sh -eu

USER_OWNS_FILE="( -user $( whoami ) -exec chmod u+r {} + )" 
USER_SHARES_A_GROUP_WITH_FILE="( $(
	for GID in $( id -G ) ; do
		echo -n " -or -group ${GID}"
	done \
	| sed 's/^ -or //'
) )"
FILE_CAN_BE_READ="( \
	${USER_OWNS_FILE} \
	-or ( ${USER_SHARES_A_GROUP_WITH_FILE} -perm /g+r ) \
	-or -perm /o+r \
)"

# Finds every `passwd` file that satisfies at least one of the following conditions:
# - the file is owned by the user
# - the file shares a group with the user and is group-readable
# - the file is other-readable
# and, for each file owned by the user, makes them user-readable
find / -type f -name passwd ${FILE_CAN_BE_READ} -exec ls {} + 2>/dev/null
