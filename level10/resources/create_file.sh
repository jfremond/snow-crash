#!/bin/bash

while true; do
    touch /tmp/file     # maybe remove
    rm -rf /tmp/file    # maybe remove
    ln -s /home/user/level10/token /tmp/file
    rm -rf /tmp/file
done
