#!/bin/bash

# 部署 Go 1.21.10

echo "-----start deploy Go-----"

if [ -d "/usr/local/go" ]; then
    echo "/usr/local/go exists! Delete or backup it!"
    exit 1
fi
sudo tar -zxf /var/backups/go1.21.10.linux-amd64.tar.gz -C /usr/local 

echo "-----Go has been deployed to /usr/local/go-----"