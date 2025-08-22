#!/bin/sh
sudo groupadd -g $UID $USER
sudo useradd -g $USER -u $UID -d /home/$USER -m $USER
sudo sh -c "printf \"$USER ALL=(ALL) NOPASSWD: ALL\\n\" >> /etc/sudoers"
sudo adduser $USER sudo

