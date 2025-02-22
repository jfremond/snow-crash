#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3006 \
  flag06
echo -n 'flag06: '
sudo -u flag06 getflag | grep -oE '[^ ]+$'
sudo userdel flag06
