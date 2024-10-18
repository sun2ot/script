#!/bin/bash

if [ ! -f "/var/backups/nvim-linux64.tar.gz" ]; then
  echo "Target nvim.tar.gz not exists!. Try to prepare by AIOS NFS..."
  if [ -d "/private/root" ]; then
    echo "AIOS NFS detected. Try to extract..."
    sudo cp /private/root/deploy/nvim-linux64.tar.gz /var/backups/ 
  else
    echo "No AIOS NFS found."
    exit 1  
  fi
fi

sudo tar -zxf /var/backups/nvim-linux64.tar.gz -C /opt
sudo ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
echo "nvim has been deployed."

