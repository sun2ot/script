#!/bin/bash

# 在用户家目录下执行指定脚本
# 输入：user_list.txt target.sh

# 检查参数是否正确
if [ $# -ne 2 ]; then
    echo "Usage: $0 <user_list.txt> <func.sh>"
    exit 1
fi

user_list="$1"
func_script="$2"

# 检查 func.sh 是否可执行
if [ ! -x "$func_script" ]; then
    echo "Error: $func_script is not executable or does not exist."
    exit 1
fi

# 逐行读取 user_list.txt
while IFS= read -r username; do
    # 检查用户是否存在
    if id "$username" &>/dev/null; then
        # 获取用户家目录
        home_dir=$(getent passwd "$username" | cut -d: -f6)

        # 检查用户家目录是否存在
        if [ -d "$home_dir" ]; then
            # 切换到用户家目录并执行 func.sh
            echo "Running $func_script in $home_dir for user $username"
            cd "$home_dir" || { echo "Error: Unable to change directory to $home_dir"; exit 1; }
            "$func_script"
            cd - >/dev/null  # 切回原始目录
        else
            echo "Error: Home directory for user $username does not exist."
        fi
    else
        echo "Error: User $username does not exist."
    fi
done < "$user_list"
