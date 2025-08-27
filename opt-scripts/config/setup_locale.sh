#!/bin/bash

# 安装中文支持包
sudo apt-get update
sudo apt-get install -y language-pack-zh-hans

# 修改 /etc/environment 文件
sudo bash -c 'cat > /etc/environment <<EOF
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh:en_US:en"
EOF'

# 新建或修改 /var/lib/locales/supported.d/local 文件
sudo mkdir -p /var/lib/locales/supported.d
sudo bash -c 'cat > /var/lib/locales/supported.d/local <<EOF
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
zh_CN.GBK GBK
zh_CN GB2312
EOF'

# 生成本地化信息
sudo locale-gen

echo -e "\e[32m中文支持包安装及环境配置完成。\e[0m"
