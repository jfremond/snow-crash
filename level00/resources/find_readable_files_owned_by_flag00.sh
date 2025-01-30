#!/bin/sh -u

USER_SHARES_A_GROUP_WITH_FILE=$(
	for gid in $( id -G ) ; do
		echo -n " -or -group $gid"
	done | sed "s/^ -or //"
)

# Find every file that satisfies the following conditions:
# - the file is owned by the user `flag00`
# - the file satisfies at least one of the following conditions:
#   - the file satisfies the following conditions:
#     - the file shares a group with the user `level01`
#     - the file is group-readable
#   - the file is other-readable
find / -type f -user flag00 \( \( \( $USER_SHARES_A_GROUP_WITH_FILE \) -perm /g+r \) -or -perm /o+r \) 2>/dev/null

exit 0
