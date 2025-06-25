#!/bin/bash

# 引入 shell 检测函数
source /usr/local/script/util/detect_shell.sh
source /usr/local/script/util/tips.sh

# 检测当前 shell 的 rc 配置文件
rc_file=$(detect_shell)
if [ "$rc_file" = "-1" ]; then
    echo -e "\e[31m无法检测到 shell 类型，无法配置 TeX Live 环境变量\e[0m"
    exit 1
fi

# 环境变量内容
export_line="export PATH=/usr/local/texlive/2025/bin/x86_64-linux:\$PATH"

# 检查并写入
if grep -Fxq "$export_line" "$rc_file"; then
    echo "TeX Live 路径已存在于 $rc_file"
else
    echo "$export_line" >> "$rc_file"
    echo "已将 TeX Live 路径添加到 $rc_file"
fi

# 提示用户激活环境
remind

exit 0
