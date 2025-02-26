#!/bin/sh -eu

FLAG=../flag

# Compile the altered version of the `getflag` program
clang -Wall -Wextra -o altered_getflag altered_getflag.c

# Execute the `altered_getflag` file and save the token to a file
./altered_getflag 14 >${FLAG}

# Remove the `altered_getflag` file
rm altered_getflag
