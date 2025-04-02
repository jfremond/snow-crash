#!/bin/sh -eu

PREVIOUS_FLAG=../../level08/flag
ADDRESS=192.168.122.214
PORT=4242
TOKEN=token
DECRYPT=./decrypt
FLAG=../flag

# Copy the `token` file from the virtual machine to the host + set its permissions
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	scp -P ${PORT} level09@${ADDRESS}:${TOKEN} .
chmod 400 ${TOKEN}

# Compile the `decrypt.c` file
clang -Wall -Wextra -o ${DECRYPT} decrypt.c

# Get the password of the `flag09` user by decrypting the `token` file
FLAG09_PASSWORD=$( ${DECRYPT} $( cat ${TOKEN} ) )

# Remove the `token` and `decrypt` files
rm -f ${TOKEN} ${DECRYPT}

# Run the `getflag` command as the `flag09` user, and save the token in a file
sshpass -p ${FLAG09_PASSWORD} 2>/dev/null \
	ssh -p ${PORT} flag09@${ADDRESS} \
		getflag \
| egrep -o '[^ ]+$' >${FLAG}
