# level13

## Steps

1. __Action__ (Guest): list the files present in the `level13` user's home directory
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals 1 file possibly of interest,
	named `level13`
	```
	.bash_logout  .bashrc  .profile  level13
	```

3. __Action__ (Guest): check the type of the `level13` file
	```sh
	file -b level13
	```

4. __Observation__ (Guest): the previous command reveals that the `level13` file
	is an ELF 32-bits executable
	```
	setuid setgid ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.24, BuildID[sha1]=0xde91cfbf70ca6632d7e4122f8210985dea778605, not stripped
	```

5. __Action__ (Guest): check the file access control list of the `level13` file
	```sh
	getfacl level13
	```

6. __Observation__ (Guest): the previous command reveals that the `level13` file
	is readable by the `level13` user
	```
	level13@SnowCrash:~$ getfacl level13
	# file: level13
	# owner: flag13
	# group: level13
	# flags: ss-
	user::rwx
	group::r-x
	other::r-x
	```

7. __Action__ (Host): copy the `level13` file from the virtual machine
	```sh
	sshpass -f level12/flag 2>/dev/null \
		scp -P 4242 level13@192.168.122.214:level13 /tmp
	```

8. __Action__ (Host): decompile the `level13` file using [dogbolt](https://dogbolt.org/),
	and manually improve the lisibility of the decompiled code

9. __Observation__ (Host): after reverse engineering the `level13` file, we obtain the following
	C code, which has a guard clause that checks if the id of the user that runs the program
	is equal to 4242, and if so, it prints the token, probably the flag that we are looking for
	```c
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <sys/types.h>
	#include <unistd.h>

	char * ft_des(char * s) {
		size_t const s_len = strlen(s);
		char         offset = 48;

		s = strdup(s);
		for (size_t i = 0; i < s_len; i += 1) {
			if ((i & 1) == 0) {
				s[i] -= offset;
				if (s[i] < ' ') {
					s[i] += 95;
				}
			} else if (__builtin_add_overflow(s[i], offset, &s[i]) || s[i] > '~') {
				__builtin_sub_overflow(s[i], 95, &s[i]);
			}
			offset += 1;
			if (offset == 54) {
				offset = 48;
			}
		}
		return s;
	}

	int main(void) {
		char const *const token = ft_des("boe]!ai0FB@.:|L6l@A?>qJ}I");
		uid_t const       uid = getuid();

		if (uid == 4242) {
			printf("your token is %s\n", token);
			free((void *)token);
			exit(EXIT_SUCCESS);
		}
		free((void *)token);
		printf("UID %d started us but we we expected %d\n", uid, 4242);
		exit(EXIT_FAILURE);
	}
	```
10. __Action__ (Host): remove the `level13` file
	```sh
	rm /tmp/level13
	```

11. __Action__ (Host): put the previous C code in a file named `altered_level13.c`,
	and modify the `main` function to remove the guard clause,
	resulting in the following new `main` function:
	```c
	int main(void) {
		char const *const token = ft_des("boe]!ai0FB@.:|L6l@A?>qJ}I");

		printf("%s\n", token);
		free((void *)token);
		exit(EXIT_SUCCESS);
	}
	```

12. __Action__ (Host): compile the `altered_level13.c` file
	```sh
	clang -Wall -Wextra -o altered_level13 altered_level13.c
	```

13. __Action__ (Host): execute the `altered_level13` file
	and save the printed token to the `flag` file
	```sh
	./altered_level13 >level13/flag
	```

14. __Action__ (Host): check if the `flag` file content is the expected flag,
	by trying to connect as the `level14` user
	```sh
	sshpass -f level13/flag 2>/dev/null \
		ssh -p 4242 level14@192.168.122.214 \
			exit \
	&& echo 'Great! The token is correct!' \
	|| echo 'Nop, the token is incorrect!'
	```

15. __Observation__ (Host): the previous command reveals that the token is correct,
	by printing the following message on stdout:  
	`Great! The token is correct!`

16. __Action__ (Host): remove the `altered_level13` and `altered_level13.c` files
	```sh
	rm altered_level13 altered_level13.c
	```
