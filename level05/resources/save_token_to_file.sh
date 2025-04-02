#!/bin/sh -eu

getflag | egrep -o '[^ ]+$' >/opt/openarenaserver/.token
