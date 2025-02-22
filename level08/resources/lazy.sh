#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3008 \
  flag08
echo -n 'flag08: '
sudo -u flag08 getflag | grep -oE '[^ ]+$'
sudo userdel flag08
