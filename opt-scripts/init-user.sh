#!/bin/bash

# 适用于 nmu AIOS 平台
# 在用户家目录下创建指向 NAS 的软链接、写入一些脚本文件和提示文档

# 检查是否传入了用户名参数
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

user="$1"

# 检查目录是否存在，如果不存在则创建目录并修改所有权和权限
if [ ! -d "/private/$user" ]; then
    mkdir "/private/$user"
    chown "$user:$user" "/private/$user"
    chmod 755 "/private/$user"
fi

# 确保/home/$user目录存在，否则ln命令会失败
if [ ! -d "/home/$user" ]; then
    echo "Error: Home directory /home/$user does not exist."
    exit 1
fi

# 创建指向 NAS 的符号链接
if [ ! -L "/home/$user/$user" ]; then
    ln -s "/private/$user" "/home/$user"
fi

cat << EOF > "/home/$user/README.txt"
以下步骤按顺序执行：

## 切换你的shell

1. 你当前的 shell 为 sh，需要切换为 bash/zsh (不知道就选bash)
2. 执行"menu"，选择 3/4，然后按提示输入密码
3. 执行 "exit" 退出登录，然后重新登录即可生效
4. 要重新登录！要重新登录！要重新登录！

## 安装conda环境

执行"menu"，选择2

## Warning!!!

1. "~/$user/" 这个路径为 "/private/$user" 的软链接，指向NAS，可以持久化存储数据。
2. "~/" 即你的家目录是一个虚拟环境，一旦环境重启即会丢失(除非备份了镜像)，所以如无必要，**禁止在这里存放任何关键数据**。
3. 如果需要上传数据，可以通过 H3C 网页端的 FTP，也可以 SFTP，不过端口记得改为你SSH连接的端口。如果是从A407机房的服务器往这里拷贝数据，通过SFTP/rsync均可。
EOF

echo "Preparation for $user completed."

exit 0
