#!/bin/bash

new_config="Subsystem sftp internal-sftp"

sudo sed -i 's|^Subsystem\s\s*sftp\s\s*/usr/lib/openssh/sftp-server\s*$|'"$new_config"'|' /etc/ssh/sshd_config

service ssh restart

echo "SSH 服务已重启，新的 sftp 配置已生效。"

