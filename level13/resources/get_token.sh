#!/bin/sh -eu

FLAG=../flag

# Compile the modified source code of the `level13` binary
clang -Wall -Wextra -o level13.out level13.c

# Execute the `level13.out` file and save the token to a file
./level13.out >${FLAG}

# Remove the `level13.out` file
rm level13.out
