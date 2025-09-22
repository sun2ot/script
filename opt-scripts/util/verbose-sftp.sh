#!/bin/bash

echo "=== SFTP 连接脚本（不推荐生产环境使用，建议自行连接）==="

read -p "请输入远程服务器主机名或IP: " HOST
read -p "请输入用户名: " USER
read -s -p "请输入密码: " PASS
echo

if [[ -z "$HOST" || -z "$USER" || -z "$PASS" ]]; then
    echo "错误：主机、用户名或密码不能为空。"
    exit 1
fi

echo "正在连接到 $USER@$HOST ..."

# 使用 sshpass 自动提供密码（需先安装 sshpass）
if ! command -v sshpass >/dev/null 2>&1; then
    echo "错误：未找到 sshpass 命令。"
    echo "Ubuntu/Debian: sudo apt install sshpass"
    echo "CentOS/RHEL: sudo yum install sshpass"
    exit 1
fi

# 启动 sftp 会话
sshpass -p "$PASS" sftp "$USER@$HOST"

# 清除密码变量
unset PASS

echo "SFTP 会话已结束。"
