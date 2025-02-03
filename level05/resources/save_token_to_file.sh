#!/bin/sh

getflag | grep -oE '[^ ]+$' >/opt/openarenaserver/.token
