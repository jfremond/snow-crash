# level09

## Steps

1. __Action__ (Guest): list the files present in the `level09` user's home directory
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals 2 files possibly of interest,
	named `level09` and `token`
	```
	.bash_logout  .bashrc  .profile  level09  token
	```

3. __Action__ (Guest): check the file access control list of both `level09` and `token` files
	```sh
	getfacl level09 token
	```

4. __Observation__ (Guest): the previous command reveals that:
	- the `level09` file:
		- is readable by the `level09` user
		- is executable by the `level09` user
		- is owned by the `flag09` user
		- has the `setuid` bit enabled

	- the `token` file:
		- is readable by everyone except the `flag09` user

	```
	# file: level09
	# owner: flag09
	# group: level09
	# flags: ss-
	user::rwx
	group::r-x
	other::r-x

	# file: token
	# owner: flag09
	# group: level09
	user::---
	group::r--
	other::r--
	```

5. __Action__ (Guest): print the content of the `token` file
	```sh
	cat token
	```

6. __Observation__ (Guest): the previous command reveals that the `token` file seems to contain
	the password to connect as the `flag09` user, but it also seems encrypted, as some characters
	are marked as non-printable on stdout: `f4kmm6p|=�p�n��DB�Du{��`

7. __Action__ (Guest): execute the `level09` file to see what it does
	```sh
	./level09
	```

8. __Observation__ (Guest): the following message appears on stdout:  
	`You need to provied only one arg.`

9. __Action__ (Guest): execute the `level09` file with only 1 argument as asked by itself
	```sh
	./level09 foobar
	```

10. __Observation__ (Guest): the following text appears on stdout: `fpqeew`.  
	Note that the printed text has exactly the same number of characters 
	as the string we sent in parameter, which suggests that the `level09` program
	applied a kind of encryption on each character of the string we passed,
	and printed the encrypted string on stdout.

11. __Action__ (Guest): execute the `level09` file with a specific string to try to understand
	which kind of encryption is applied
	```sh
	./level09 'aaaaa'
	```

12. __Observation__ (Guest): the following text appears on stdout: `abcde`  
	which suggests that the encryption applied by the `level09` program nothing more than
	a shift of N on each character of the string, where N is the position of the character

13. __Action__ (Guest): execute the `level09` file with another specific string
	to confirm or refute our assumption
	```sh
	./level09 $( echo -e 'I\x1Fjloo\x1Am`\\\x16<U`W' )
	```

14. __Observation__ (Guest): the following text appears on stdout: `I lost the Game`  
	confirming our assumption. Knowing that, we also can think that the content of the `token` file
	has been encrypted using the `level09` program, and this encryption algorithm is reversable.

15. __Action__ (Host): implement a short program in C named `decrypt.c`
	that takes any number of strings encrypted by the `level09` program in parameter,
	and decrypts them by applying the reverse operation
	```c
	#include <stdio.h>

	int main(int const ac, char *const *const av) {
		for (size_t i = 1; i < (size_t)ac; ++i) {
			for (size_t j = 0; av[i][j] != '\0'; ++j) {
				av[i][j] -= j;
			}
			printf("%s\n", av[i]);
		}
		return 0;
	}
	```

16. __Action__ (Host): compile the previous program
	```sh
	clang -Wall -Wextra -o decrypt decrypt.c
	```

17. __Action__ (Host): copy the `token` file from the virtual machine
	```sh
	sshpass -f level08/flag 2>/dev/null \
		scp -P 4242 level09@192.168.122.214:token token
	chmod 400 token
	```

18. __Action__ (Host): execute the `decrypt` file with the content of the `token` file
	```sh
	./decrypt $( cat token )
	```

19. __Observation__ (Host): the following text appears on stdout: `f3iji1ju5yuevaus41q1afiuq`  
	which is more likely to be the clear password of the `flag09` user

20. __Action__ (Host): run the `getflag` command as the `flag09` user
	and save the token in the `flag` file
	```sh
	sshpass -p f3iji1ju5yuevaus41q1afiuq 2>/dev/null \
		ssh -p 4242 flag09@192.168.122.214 \
			getflag \
	| egrep -o '[^ ]+$' >level09/flag
	```

21. __Action__(Host): remove the `token`, `decrypt`, and `decrypt.c` files
	```sh
	rm token decrypt decrypt.c
	```
