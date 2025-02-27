#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char * ft_des(char * s) {
	size_t const s_len = strlen(s);
	char         offset = 48;

	s = strdup(s);
	for (size_t i = 0; i < s_len; i += 1) {
		if ((i & 1) == 0) { // even position
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

	printf("%s\n", token);
	free((void *)token);
	exit(EXIT_SUCCESS);
}
