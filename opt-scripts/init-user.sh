#!/bin/bash

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

# conda 一键安装脚本
cp miniconda3.sh /home/$user

cat << EOF > "/home/$user/README.txt"
## 关于shell

1. 你当前的 shell 为 sh，需要切换为 bash/zsh (不知道就选bash)
2. 执行 "chsh"，按提示输入你的密码后，按回车
3. 你会看到一个 "/bin/sh" 字样的提示，在那一行的最后输入 "/bin/bash" 然后回车即可
4. 执行 "exit" 退出登录，然后重新登录即可生效
5. 要重新登录！要重新登录！要重新登录！

## 关于conda环境

1. 你的家目录下有一个 "miniconda3.sh" 文件
2. 执行 "./miniconda3.sh" 即可自动安装conda环境
3. 执行完成后，可以执行 "rm ~/miniconda3.sh" 删除该脚本(可选，删不删都行)

## Warning!!!

1. "~/$user/" 这个路径为 "/private/$user" 的软链接，指向NAS，可以持久化存储数据。
2. "~/" 即你的家目录是一个虚拟环境，一旦环境重启即会丢失(除非备份了镜像)，所以如无必要，**禁止在这里存放任何关键数据**。
3. 如果需要上传数据，可以通过 H3C 网页端的 FTP，也可以 SFTP，不过端口记得改为你SSH连接的端口。如果是从A407机房的服务器往这里拷贝数据，通过SFTP/rsync均可。
4. 登录时输出的那个 ASCII Tensorflow 提示信息暂时没有找到删除的方法，先让它苟活一段时日吧。
EOF

echo "Preparation for $user completed."

exit 0
