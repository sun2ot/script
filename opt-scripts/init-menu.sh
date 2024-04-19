#!/bin/bash

# 准备执行menu.sh所需的前置脚本

ln -s .bash_profile /etc/skel/.bash_profile
ln -s .zsh_profile /etc/skel/.zsh_profile

if [ -d "/usr/local/script" ]; then
    echo "/usr/local/script already exists."
else
    mkdir -p /usr/local/script
fi

ln -s chsh-zsh.sh /usr/local/script/chsh-zsh.sh
ln -s miniconda3.sh /usr/local/script/miniconda3.sh
ln -s proxy.sh /usr/local/script/proxy.sh

ln -s menu.sh /usr/local/bin/menu

