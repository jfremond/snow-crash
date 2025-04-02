#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define BASE "0123456789ABCDEF"
#define DELETE 0x7F

int main(int const ac, char const *const *const av) {
	for (size_t i = 1; i < (size_t)ac; i += 1) {
		char const *const hexadecimal_string = av[i];
		size_t const len = strlen(hexadecimal_string);

		if ((len & 1) != 0) {
			fprintf(stderr, "error: every byte must be represented with 2 digits\n");
			continue;
		}
		if (strspn(hexadecimal_string, BASE) != len) {
			fprintf(stderr, "error: only hexadecimal digits are allowed\n");
			continue;
		}
		for (size_t j = 0; j < len; j += 2) {
			uint8_t const byte =
				((uint8_t)(strchr(BASE, hexadecimal_string[j]) - BASE) << 4)
				+ (uint8_t)(strchr(BASE, hexadecimal_string[j + 1]) - BASE);

			if (isprint(byte)) {
				putchar(byte);
			} else {
				printf(byte == DELETE ? "\e[1D" : "□");
			}
		}
		putchar('\n');
	}
	return 0;
}
