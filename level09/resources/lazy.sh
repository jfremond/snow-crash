#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3009 \
  flag09
echo -n 'flag09: '
sudo -u flag09 getflag | grep -oE '[^ ]+$'
sudo userdel flag09
