#!/bin/sh -eu

FLAG=../flag

# Compile the altered version of the `level13` program
clang -Wall -Wextra -o altered_level13 altered_level13.c

# Execute the `altered_level13` file and save the token to a file
./altered_level13 >${FLAG}

# Remove the `altered_level13` file
rm altered_level13
