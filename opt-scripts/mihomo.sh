#!/bin/bash

# 一键部署mihomo代理
# ⚠️ 配置文件config.yaml可能过时，后续管理员注意替换

echo "-----start deploy mihomo-----"
sudo tar -zxf /var/backups/mihomo.tar.gz -C /opt   
sudo nohup /opt/mihomo/mihomo -d /opt/mihomo &
echo "-----mihomo deploy done-----"