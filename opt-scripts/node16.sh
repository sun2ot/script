#!/bin/bash

# 适用于 nmu AIOS
# 部署 Node.js v16.20.2

if [ ! -f "/var/backups/node-v16.20.2-linux-x64.tar.xz" ]; then
  echo "Target node.tar.gz not exists!. Try to prepare by AIOS NFS..."
  if [ -d "/private/root" ]; then
    echo "AIOS NFS detected. Try to extract..."
    sudo cp /private/root/deploy/node-v16.20.2-linux-x64.tar.xz /var/backups/ 
  else
    echo "No AIOS NFS found."
    exit 1  
  fi
else
  sudo tar -Jxf /var/backups/node-v16.20.2-linux-x64.tar.xz -C /opt
  echo "Node.js v16.20.2 has been deployed."
fi


