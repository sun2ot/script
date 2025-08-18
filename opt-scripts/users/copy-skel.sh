#!/bin/bash

# 用法示例：./copy-skel.sh user.txt
# user.txt 为用户名列表，每行一个用户名

if [ $# -ne 1 ]; then
    echo "Usage: $0 <user_list_file>"
    exit 1
fi

user_list_file="$1"

if [ ! -f "$user_list_file" ]; then
    echo "Error: User list file '$user_list_file' does not exist."
    exit 1
fi

while IFS= read -r user || [[ -n "$user" ]]; do
    user=$(echo "$user" | xargs)
    if [ -z "$user" ]; then
        continue
    fi
    
    # 获取家目录路径
    user_home=$(getent passwd "$user" | cut -d: -f6)
    
    if [ -z "$user_home" ]; then
        echo "Warning: User '$user' does not exist, skipping."
        continue
    fi
    
    if [ ! -d "$user_home" ]; then
        echo "Warning: Home directory '$user_home' for user '$user' does not exist, skipping."
        continue
    fi

    echo "Copying /etc/skel to $user's home directory: $user_home"
    sudo cp -a /etc/skel/. "$user_home/"

    echo "Setting ownership of $user_home to $user:$user"
    sudo chown -R "$user":"$user" "$user_home"
done < "$user_list_file"

exit 0
