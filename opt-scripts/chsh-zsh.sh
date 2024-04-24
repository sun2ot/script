#!/bin/bash

# 魔改版 oh-my-zsh 安装脚本，采用 Gitee 镜像实现
# updated: 2024-04-24
# 如后续官方脚本发生变化，则该脚本可能失效

# Define the Gitee mirror URL for oh-my-zsh
GITEE_REPO="mirrors/oh-my-zsh"
GITEE_REMOTE="https://gitee.com/${GITEE_REPO}.git"

# Download the install script from Gitee
wget -O install.sh https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh

# Replace the default GitHub repository with the Gitee mirror
sed -i "s|REPO=\${REPO:-ohmyzsh/ohmyzsh}|REPO=\${REPO:-${GITEE_REPO}}|g" install.sh
sed -i "s|REMOTE=\${REMOTE:-https://github.com/\${REPO}.git}|REMOTE=\${REMOTE:-${GITEE_REMOTE}}|g" install.sh

# Make the script executable
chmod +x install.sh

# Execute the modified install script
./install.sh

# Clean up the install script
rm install.sh

echo "oh-my-zsh installation completed using Gitee mirror."
