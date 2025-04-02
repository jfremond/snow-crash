#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3000 \
  flag00
echo -n 'flag00: '
sudo -u flag00 getflag | egrep -o '[^ ]+$'
sudo userdel flag00
