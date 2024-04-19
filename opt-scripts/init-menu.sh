#!/bin/bash

# 准备执行menu.sh所需的前置脚本

cp .bash_profile .zsh_profile /etc/skel
cp chsh-zsh.sh miniconda3.sh proxy.sh /usr/local/script
cp menu.sh /usr/local/bin/
