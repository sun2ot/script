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
if [ ! -d "/private/$user" ]; then
    echo "NFS has no this user's storage. Will create..."
    mkdir "/private/$user"
fi

# AIOS的NFS中默认权限为777
# 方便和安全只能二选一
# sudo chown $user:$user /private/$user
# sudo chmod 755 /private/$user

# 确保/home/$user目录存在，否则ln命令会失败
if [ ! -d "/home/$user" ]; then
    echo "Error: Home directory /home/$user does not exist."
    exit 1
fi

# 创建指向NFS的符号链接
if [ ! -L "/home/$user/$user" ]; then
    ln -s /private/$user /home/$user/$user
    echo "/home/$user/$user has been linked to NFS"
fi

# sudo chown $user:$user /home/$user/$user

echo "Preparation for $user completed."

exit 0
