#!/bin/bash

# 检查是否提供了进程PID作为参数
if [ -z "$1" ]; then
	echo "Usage: $0 <PID>"
	exit 1
fi

# 获取用户输入的PID
PID=$1

# 获取所有正在运行的容器ID
containers=$(docker ps -q)

# 标志变量，用于判断是否找到对应的容器
found=false

# 遍历每个容器，检查是否包含指定的PID
for container in $containers; do
	echo $container
	if docker top $container | grep $PID; then
		echo "Process $PID is running in container: $container"
		found=true
		break
	fi
done

# 如果没有找到对应的容器
if ! $found; then
	echo "Process $PID not found in any running containers."
fi
