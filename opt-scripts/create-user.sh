#!/bin/bash

# 定义要创建的用户列表
user_list=("yzh" "yzy" "wwl" "cfp" "wym" "wyy" "wt" "jbx" "zbj" "hml")

# 循环遍历用户列表
for user in "${user_list[@]}"
do
    # 创建用户
    sudo useradd -m $user
    
    # 设置密码
    echo "正在设置 $user 的密码："
    echo -e "123456" | passwd $user
done

