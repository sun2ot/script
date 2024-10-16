#!/bin/bash

# 适用于 nmu AIOS 平台
# 将 NFS 中的包复制到 /var/backups/ 下

echo "extract /private/root/deploy/* to /var/backups/"
cp -r /private/root/deploy/* /var/backups/
echo "extract done."