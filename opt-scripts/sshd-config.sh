#!/bin/bash

# 适用于 nmu AIOS 平台
# 针对 ssh 配置做出以下修改：
# 1. 修改 sftp 的方式以解决连接时阻塞的问题
# 2. 关闭 sshd 的 UsePAM 选项，否则普通用户无法登录

sftp_config="Subsystem sftp internal-sftp"
pam_config="UsePAM no"

# 备份原始的 sshd_config 文件
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

sudo sed -i "s|^\s*Subsystem\s\+sftp\s\+/usr/lib/openssh/sftp-server\s*$|$sftp_config|" /etc/ssh/sshd_config
sudo sed -i "s|^\s*UsePAM\s\+yes\s*$|$pam_config|" /etc/ssh/sshd_config

sudo service ssh restart

echo "SSH 服务已重启，新的配置已生效。"

