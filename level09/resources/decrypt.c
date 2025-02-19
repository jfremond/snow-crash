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
