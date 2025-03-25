#!/bin/sh -eu

PREVIOUS_FLAG=../../level09/flag
ADDRESS=192.168.122.214
PORT=4242
FLAG=../flag

# Get the password of the `flag10` user by running the `get_flag10_password.sh` script
FLAG10_PASSWORD=$(
	sshpass -f ${PREVIOUS_FLAG} <get_flag10_password.sh 2>/dev/null \
		ssh -p ${PORT} level10@${ADDRESS} \
			sh -s
)

# Run the `getflag` command as the `flag10` user, and save the token in a file
sshpass -p ${FLAG10_PASSWORD} 2>/dev/null \
	ssh -p ${PORT} flag10@${ADDRESS} \
		getflag \
| egrep -o '[^ ]+$' >${FLAG}
