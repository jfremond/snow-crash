#!/bin/sh

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3000 \
  flag00
echo -n 'flag00: '
sudo -u flag00 getflag | grep -oE '[^ ]+$'
sudo userdel flag00
