#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: '$1' is not a file or does not exist."
    exit 1
fi
dat="$1"
7za x -so $1 > /tmp/update.tar
tar vxf /tmp/update.tar -C /
rm /tmp/update.tar

chmod 755 /usr/local/sbin/*
chmod 755 /home/alike/Alike/hooks/*

