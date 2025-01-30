#!/bin/sh -u

LEVEL00_PASSWORD=level00
ADDRESS=192.168.122.214
PORT=4242
TMP=./tmp
FLAG=../flag

# Connect to the virtual machine using SSH and run the script
# to find every file that is owned by the user `flag00`
# and can be read by the user `level00`
READABLE_FILES_OWNED_BY_FLAG00=$(
	sshpass -p ${LEVEL00_PASSWORD} \
		ssh -p ${PORT} level00@${ADDRESS} 'sh -s' \
			<find_readable_files_owned_by_flag00.sh \
			2>/dev/null
)

mkdir ${TMP}
for READABLE_FILE_OWNED_BY_FLAG00 in ${READABLE_FILES_OWNED_BY_FLAG00}; do
	LOCAL_FILE="${TMP}/$(
		echo "${READABLE_FILE_OWNED_BY_FLAG00}" \
		| sed 's/\./_/g' \
		| sed 's/\//./g' \
		| sed 's/^\.//g'
	)"

	# Copy the file from the virtual machine to the host + set its permissions
	sshpass -p ${LEVEL00_PASSWORD} \
		scp -P ${PORT} level00@${ADDRESS}:${READABLE_FILE_OWNED_BY_FLAG00} ${LOCAL_FILE} 2>/dev/null
	chmod 600 ${LOCAL_FILE}

	# Decipher the content of the file using a simple Cesar shift of 11
	POTENTIAL_PASSWORD=$(tr A-Za-z L-ZA-Kl-za-k <${LOCAL_FILE})

	# Try to connect to the `flag00` account
	if
		sshpass -p ${POTENTIAL_PASSWORD} \
			ssh -p ${PORT} flag00@${ADDRESS} "getflag | grep -oE '[^ ]+$'" >${FLAG} 2>/dev/null
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
