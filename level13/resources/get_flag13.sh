#!/bin/sh

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3013 \
  flag13
echo -n 'flag13: '
sudo -u flag13 getflag | grep -oE '[^ ]+$'
sudo userdel flag13
