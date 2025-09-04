#!/bin/bash

# 传入用户名列表，批量执行 create-user.sh

# Warning:
# 1. 要使用这个脚本，你需要确保 create-user.sh 和 batch-create-user.sh 位于同一目录
# 2. 脚本需要传入一个包含要初始化的用户列表的文本文件(每行一个用户名)

if [ $# -ne 1 ]; then
    echo "Usage: $0 <user_list_file>"
    exit 1
fi

user_list_file="$1"

if [ ! -f "$user_list_file" ]; then
    echo "Error: User list file '$user_list_file' does not exist."
    exit 1
fi

# 逐行读取用户列表文件
while IFS= read -r user || [[ -n "$user" ]]
do
    sudo ./create-user.sh "$user"
done < "$user_list_file"

exit 0