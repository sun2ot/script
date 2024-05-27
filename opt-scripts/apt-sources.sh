#!/bin/bash

# 适用于 nmu AIOS 平台
# 修改apt源(Ubuntu 18.04 LTS bionic)

# 因为默认好像有一个什么备份，这里换个名字
cp /etc/apt/sources.list /etc/apt/sources.yzh.list.bak

# 创建一个新的源列表文件
sudo tee /etc/apt/sources.list >/dev/null <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
EOF

echo "APT source has been replaced by tsinghua mirrors successfully"
echo "Version: Ubuntu 18.04 LTS (bionic)"
