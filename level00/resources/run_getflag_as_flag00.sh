#!/bin/sh -eu

LEVEL00_PASSWORD=level00
ADDRESS=192.168.122.214
PORT=4242
TMP=./tmp
FLAG=../flag

# Connect to the virtual machine using SSH and run the script
# to find every file that is owned by the `flag00` user
# and can be read by the `level00` user
READABLE_FILES_OWNED_BY_FLAG00=$(
	sshpass -p ${LEVEL00_PASSWORD} <find_readable_files_owned_by_flag00.sh 2>/dev/null \
		ssh -p ${PORT} level00@${ADDRESS} 'sh -s'
)

mkdir ${TMP}
for READABLE_FILE_OWNED_BY_FLAG00 in ${READABLE_FILES_OWNED_BY_FLAG00}; do
	LOCAL_FILE=${TMP}/$(
		echo ${READABLE_FILE_OWNED_BY_FLAG00} | sed 's/\./_/g' | sed 's/\//./g' | sed 's/^\.//g'
	)

	# Copy the file from the virtual machine to the host + set its permissions
	sshpass -p ${LEVEL00_PASSWORD} 2>/dev/null \
		scp -P ${PORT} level00@${ADDRESS}:${READABLE_FILE_OWNED_BY_FLAG00} ${LOCAL_FILE}
	chmod 600 ${LOCAL_FILE}

	# Decipher the content of the file using a simple Cesar shift of 11
	POTENTIAL_PASSWORD=$( tr a-z l-za-k <${LOCAL_FILE} )

	# Try to connect to the virtual machine and run the `getflag` command as the `flag00` user
	if
		sshpass -p ${POTENTIAL_PASSWORD} >${FLAG} 2>/dev/null \
			ssh -p ${PORT} flag00@${ADDRESS} "getflag | grep -oE '[^ ]+$'"
	then
		# Found the correct password and saved the flag
		rm -rf ${TMP}
		exit 0
	fi
done

# Did not find the correct password, and thus could not get the flag
rm -f ${FLAG}
rm -rf ${TMP}
echo >&2 'error: none of the potential passwords is the correct one'
exit 1
