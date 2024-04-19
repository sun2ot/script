#!/bin/bash

# 准备执行menu.sh所需的前置脚本
# 注意，需在opt-scripts路径下执行该脚本

ln -s $(realpath .bash_profile) /etc/skel/.bash_profile
ln -s $(realpath .zsh_profile) /etc/skel/.zsh_profile

if [ -d "/usr/local/script" ]; then
    echo "/usr/local/script already exists."
else
    mkdir -p /usr/local/script
fi

ln -s $(realpath chsh-zsh.sh) /usr/local/script/chsh-zsh.sh
ln -s $(realpath miniconda3.sh) /usr/local/script/miniconda3.sh
ln -s $(realpath proxy.sh) /usr/local/script/proxy.sh

ln -s $(realpath menu.sh) /usr/local/bin/menu

