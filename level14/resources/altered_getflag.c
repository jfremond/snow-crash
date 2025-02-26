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
