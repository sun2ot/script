#!/bin/bash

# 创建新用户并初始化密码为123456

# 检查是否传入了用户名参数
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

user="$1"

# 设置初始密码
INITIAL_PASSWORD="123456"

# 创建用户
sudo useradd -m $user
sudo cp -a /etc/skel/. /home/$user
sudo chown -R $user:$user /home/$user
sudo chmod 754 /home/$user

# 设置密码
echo "正在设置 $user 的默认密码："
echo "$user:$INITIAL_PASSWORD" | chpasswd

