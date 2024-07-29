#!/bin/bash

# 适用于 nmu AIOS 平台
# 将所有AIOS平台需要部署的脚本全部封装在这里

./dns.sh
./sshd-config.sh
./apt-sources.sh
./install-aios.sh
./prepare.sh
./init-menu.sh
