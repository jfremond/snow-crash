#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3007 \
  flag07
echo -n 'flag07: '
sudo -u flag07 getflag | egrep -o '[^ ]+$'
sudo userdel flag07
