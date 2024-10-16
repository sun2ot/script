#!/bin/bash

# 部署 jdk 11

if [ ! -f "/var/backups/jdk-11.0.22_linux-x64_bin.tar.gz" ]; then
  echo "Target jdk.tar.gz not exists!. Try to prepare by AIOS NFS..."
  if [ -d "/private/root" ]; then
    echo "AIOS NFS detected. Try to extract..."
    sudo cp /private/root/deploy/jdk-11.0.22_linux-x64_bin.tar.gz /var/backups/ 
  else
    echo "No AIOS NFS found."
    exit 1  
  fi
else
  sudo tar -zxf /var/backups/jdk-11.0.22_linux-x64_bin.tar.gz -C /opt
  echo "jdk-11.0.22 has been deployed."
fi


