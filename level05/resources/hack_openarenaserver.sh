#!/bin/sh

getflag | grep -oE '[^ ]+$' >/opt/openarenaserver/.token

exit 0
