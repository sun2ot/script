#!/bin/bash

# 创建新用户并初始化密码为123456

# 检查是否传入了用户名参数
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

user="$1"

# 创建用户
sudo useradd -m $user

# 设置密码
echo "正在设置 $user 的密码："
echo -e "123456" | passwd $user


