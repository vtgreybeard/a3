#!/bin/bash


wget https://raw.githubusercontent.com/vtgreybeard/a3/main/a3pkgs.lst

sed -i 's/^#\s*\(.*community.*\)/\1/' /etc/apk/repositories

apk update
apk add sudo
apk add shadow
apk add findutils
apk add bash
apk add openrc docker
groupadd sudo
service docker start
rc-update add docker default
cat a3pkgs.lst | xargs apk add
USER="alike"
PASS="alike"
adduser -D $USER
echo "$USER:$PASS" | chpasswd
addgroup alike sudo

rm a3pkgs.lst
mkdir -p /usr/local/sbin
mkdir -p /home/alike/configs
chown alike:alike /home/alike/configs
chown alike:alike /usr/local/sbin
mkdir /mnt/ads
mkdir /mnt/ods


wget -qO qs.sh 'https://raw.githubusercontent.com/vtgreybeard/a3/main/host/a3_update.sh' && bash qs.sh -quiet $@
if [[ -f qs.sh ]]; then
        rm qs.sh
fi
