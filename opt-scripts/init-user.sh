#!/bin/bash

# 适用于 nmu AIOS 平台
# 在用户家目录下创建指向 NAS 的软链接、写入一些脚本文件和提示文档

# 检查是否传入了用户名参数
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

user="$1"

# 检查NFS下是否存在用户存储，如果不存在则创建目录并修改所有权和权限
if [ ! -d "/private/$USER" ]; then
    mkdir "/private/$USER"
    sudo chown "$USER:$USER" "/private/$USER"
    sudo chmod 755 "/private/$USER"
fi

# 确保/home/$user目录存在，否则ln命令会失败
if [ ! -d "/home/$USER" ]; then
    echo "Error: Home directory /home/$USER does not exist."
    exit 1
fi

# 创建指向NFS的符号链接
if [ ! -L "/home/$USER/$USER" ]; then
    ln -s "/private/$USER" "/home/$USER"
    sudo chown "$USER:$USER" "/home/$USER"
fi

echo "Preparation for $USER completed."

exit 0
