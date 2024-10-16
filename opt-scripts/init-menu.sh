#!/bin/bash

# 准备执行menu.sh所需的前置脚本
# 注意，需在opt-scripts路径下执行该脚本

if [ -d "/usr/local/script" ]; then
    echo -e "/usr/local/script already exists. \e[33mDeleting...\e[0m"
    rm -rf /usr/local/script
fi
mkdir -p /usr/local/script

# 考虑了一下, 基于学校当前这个狗屎粑粑一样的运维现状, 直接将整个目录丢过去比较靠谱, 不再进行软链接
cp -r config /usr/local/script/config
cp -r util /usr/local/script/util
cp -r extract /usr/local/script/extract
cp -r install /usr/local/script/install


# 链接主菜单
if [ -L "/usr/local/bin/menu" ]; then
    echo -e "/usr/local/bin/menu already exists. \e[31mDeleting...\e[0m"
    rm /usr/local/bin/menu
fi
ln -s $(realpath menu.sh) /usr/local/bin/menu
echo -e "\e[32mmenu.sh linked.\e[0m"

