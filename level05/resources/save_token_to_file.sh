#!/bin/sh -eu

getflag | grep -oE '[^ ]+$' >/opt/openarenaserver/.token
