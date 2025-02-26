# level14

## Steps

1. __Action__ (Guest): check the content of the `level14` user home directory once connected
	```sh
	ls -A
	```

2. __Observation__ (Guest): the previous command reveals nothing of interest
	```
	.bash_logout  .bashrc  .profile
	```

3. __Action__ (Guest): search for every file owned by the `flag14` user on the system
	```sh
	find / -user flag14 2>/dev/null
	```

4. __Observation__ (Guest): the previous command reveals that no file is owned by the `flag14` user

5. __Action__ (Guest): search for every file which is part of the `flag14` group on the system
	```sh
	find / -group flag14 2>/dev/null
	```

6. __Observation__ (Guest): the previous command reveals that no file is part of the `flag14` group

7. __Action__ (Guest): check the permissions of the `getflag` file
	```sh
	getfacl $( which getflag )
	```

8. __Observation__ (Guest): the previous command reveals that the `getflag` file
	is readable by the `level14` user
	```
	getfacl: Removing leading '/' from absolute path names
	# file: bin/getflag
	# owner: root
	# group: root
	user::rwx
	group::r-x
	other::r-x
	```

9. __Action__ (Host): copy the `getflag` file from the virtual machine
	```sh
	sshpass -f level14/flag 2>/dev/null \
		scp level14@192.168.122.214:/bin/getflag .
	```

10. __Action__ (Host): decompile the `getflag` file using [dogbolt](https://dogbolt.org/),
	and manually improve the lisibility of the decompiled code

11. __Observation__ (Host): after reverse engineering the `getflag` file, we obtain the following
	C code, which stores all the flags staticly, encrypted, but the function to decrypt them
	is also provided in the binary
	```c
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <sys/types.h>
	#include <unistd.h>

	#define ROOT 0

	enum uids {
		FLAG00 = 3000,
		FLAG01,
		FLAG02,
		FLAG03,
		FLAG04,
		FLAG05,
		FLAG06,
		FLAG07,
		FLAG08,
		FLAG09,
		FLAG10,
		FLAG11,
		FLAG12,
		FLAG13,
		FLAG14,
	};

	char * ft_des(char const *const s) {
		size_t const s_len = strlen(s);
		char         offset = 48;
		char *const  dup = strdup(s);

		for (size_t i = 0; i < s_len; i += 1) {
			if ((i & 1) == 0) {
				dup[i] -= offset;
				if (dup[i] < ' ') {
					dup[i] += 95;
				}
			} else if (__builtin_add_overflow(dup[i], offset, &dup[i]) || dup[i] > '~') {
				__builtin_sub_overflow(dup[i], 95, &dup[i]);
			}
			offset += 1;
			if (offset == 54) {
				offset = 48;
			}
		}
		return dup;
	}

	int main(void) {
		uid_t const  uid = getuid();
		char const * token = NULL;

		printf("Check flag.Here is your token : ");
		switch (uid) {

		case ROOT:
			printf("You are root are you that dumb ?\n");
			exit(EXIT_FAILURE);

		case FLAG00:
			token = ft_des("I`fA>_88eEd:=`85h0D8HE>,D");
			break;

		case FLAG01:
			token = ft_des("7`4Ci4=^d=J,?>i;6,7d416,7");
			break;

		case FLAG02:
			token = ft_des("<>B16\\AD<C6,G_<1>^7ci>l4B");
			break;

		case FLAG03:
			token = ft_des("B8b:6,3fj7:,;bh>D@>8i:6@D");
			break;

		case FLAG04:
			token = ft_des("?4d@:,C>8C60G>8:h:Gb4?l,A");
			break;

		case FLAG05:
			token = ft_des("G8H.6,=4k5J0<cd/D@>>B:>:4");
			break;

		case FLAG06:
			token = ft_des("H8B8h_20B4J43><8>\\ED<;j@3");
			break;

		case FLAG07:
			token = ft_des("78H:J4<4<9i_I4k0J^5>B1j`9");
			break;

		case FLAG08:
			token = ft_des("bci`mC{)jxkn<\"uD~6%g7FK`7");
			break;

		case FLAG09:
			token = ft_des("Dc6m~;}f8Cj#xFkel;#&ycfbK");
			break;

		case FLAG10:
			token = ft_des("74H9D^3ed7k05445J0E4e;Da4");
			break;

		case FLAG11:
			token = ft_des("70hCi,E44Df[A4B/J@3f<=:`D");
			break;

		case FLAG12:
			token = ft_des("8_Dw\"4#?+3i]q&;p6 gtw88EC");
			break;

		case FLAG13:
			token = ft_des("boe]!ai0FB@.:|L6l@A?>qJ}I");
			break;

		case FLAG14:
			token = ft_des("g <t61:|4_|!@IF.-62FH&G~DCK/Ekrvvdwz?v|");
			break;

		default:
			printf("\nNope there is no token here for you sorry. Try again :)\n");
			exit(EXIT_FAILURE);
		}
		printf("%s\n", token);
		free((void *)token);
		exit(EXIT_SUCCESS);
	}
	```

12. __Action__ (Host): implement an altered version of the `getflag` program,
	removing the check on the user id, and printing either all the flags or the requested ones
	```c
	#include <ctype.h>
	#include <errno.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	enum uids {
		FLAG00,
		FLAG01,
		FLAG02,
		FLAG03,
		FLAG04,
		FLAG05,
		FLAG06,
		FLAG07,
		FLAG08,
		FLAG09,
		FLAG10,
		FLAG11,
		FLAG12,
		FLAG13,
		FLAG14,
	};

	size_t atouz(char const *s) {
		size_t n = 0;

		s += strspn(s, " \f\n\r\t\v");
		if (*s == '+') {
			s += 1;
		}
		s += strspn(s, "0");
		while (isdigit(*s)) {
			if (
				   __builtin_mul_overflow(n, 10, &n)
				|| __builtin_add_overflow(n, *s - '0', &n)
			) {
				errno = ERANGE;
				return (size_t)-1;
			}
			s += 1;
		}
		return n;
	}

	char * ft_des(char const *const s) {
		size_t const s_len = strlen(s);
		char         offset = 48;
		char *const  dup = strdup(s);

		for (size_t i = 0; i < s_len; i += 1) {
			if ((i & 1) == 0) {
				dup[i] -= offset;
				if (dup[i] < ' ') {
					dup[i] += 95;
				}
			} else if (__builtin_add_overflow(dup[i], offset, &dup[i]) || dup[i] > '~') {
				__builtin_sub_overflow(dup[i], 95, &dup[i]);
			}
			offset += 1;
			if (offset == 54) {
				offset = 48;
			}
		}
		return dup;
	}

	int main(int const ac, char const *const *const av) {
		char const *const encrypted_tokens[] = {
			[FLAG00] = "I`fA>_88eEd:=`85h0D8HE>,D",
			[FLAG01] = "7`4Ci4=^d=J,?>i;6,7d416,7",
			[FLAG02] = "<>B16\\AD<C6,G_<1>^7ci>l4B",
			[FLAG03] = "B8b:6,3fj7:,;bh>D@>8i:6@D",
			[FLAG04] = "?4d@:,C>8C60G>8:h:Gb4?l,A",
			[FLAG05] = "G8H.6,=4k5J0<cd/D@>>B:>:4",
			[FLAG06] = "H8B8h_20B4J43><8>\\ED<;j@3",
			[FLAG07] = "78H:J4<4<9i_I4k0J^5>B1j`9",
			[FLAG08] = "bci`mC{)jxkn<\"uD~6%g7FK`7",
			[FLAG09] = "Dc6m~;}f8Cj#xFkel;#&ycfbK",
			[FLAG10] = "74H9D^3ed7k05445J0E4e;Da4",
			[FLAG11] = "70hCi,E44Df[A4B/J@3f<=:`D",
			[FLAG12] = "8_Dw\"4#?+3i]q&;p6 gtw88EC",
			[FLAG13] = "boe]!ai0FB@.:|L6l@A?>qJ}I",
			[FLAG14] = "g <t61:|4_|!@IF.-62FH&G~DCK/Ekrvvdwz?v|",
		};
		size_t const encrypted_tokens_len
			= sizeof(encrypted_tokens) / sizeof(*encrypted_tokens);

		if (ac < 2) {
			for (size_t i = 0; i < encrypted_tokens_len; i += 1) {
				char const *const token = ft_des(encrypted_tokens[i]);
		
				printf("flag%.2zu: %s\n", i, token);
				free((void *)token);
			}
		} else {
			for (size_t i = 1; i < (size_t)ac; i += 1) {
				size_t const flag = atouz(av[i]);

				if (errno != 0 || flag >= encrypted_tokens_len) {
					fprintf(stderr, "`%s`: invalid flag number\n", av[i]);
					continue;
				}
				char const *const token = ft_des(encrypted_tokens[flag]);

				printf("%s\n", token);
				free((void *)token);
			}
		}
		exit(EXIT_SUCCESS);
	}
	```
	and save it in a file named `altered_getflag.c`

13. __Action__ (Host): compile the altered version of the `getflag` program
	```sh
	clang -Wall -Wextra -o altered_getflag.out
	```

14. __Action__ (Host): execute the altered version of the `getflag` program
	to get the fifteenth flag
	```sh
	./altered_getflag.out 14
	```

15. __Observation__ (Host): the following text appears on stdout:
	`flag14: 7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ`

16. __Action__ (Host): remove the `getflag`, `altered_getflag.c`, and `altered_getflag.out` files
	```sh
	rm getflag altered_getflag.c altered_getflag.out
	```
