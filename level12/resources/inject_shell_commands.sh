#!/bin/sh -eu

curl localhost:4646 -d 'x=`/*/INJECTED_SHELL_COMMANDS`'
