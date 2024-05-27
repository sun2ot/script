#!/bin/bash

# 适用于 nmu AIOS 平台
# 一键部署mihomo代理
# ⚠️ 配置文件config.yaml可能过时，后续管理员注意替换

echo "-----start deploy mihomo-----"
sudo tar -zxvf /private/root/mihomo.tar.gz -C /opt   
sudo nohup /opt/mihomo/mihomo -d /opt/mihomo &
echo "-----mihomo deploy done-----"