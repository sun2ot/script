#!/bin/bash

# 适用于 nmu AIOS 平台
# 将所有AIOS平台需要部署的脚本全部封装在这里

config/dns.sh
config/sshd-config.sh
config/apt-sources.sh
install/install-aios.sh
extract/prepare.sh
./init-menu.sh
