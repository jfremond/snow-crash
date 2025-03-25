#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3011 \
  flag11
echo -n 'flag11: '
sudo -u flag11 getflag | egrep -o '[^ ]+$'
sudo userdel flag11
