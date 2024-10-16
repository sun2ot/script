#!/bin/bash

# 错误处理函数
error_handler() {
    local error_code=$1
    case $error_code in
        1)
            echo -e "\e[31m[error 1]\e[0m 不支持当前shell: $(basename "$SHELL")"
            ;;
        2)
            echo -e "\e[31m[error 2]\e[0m $(basename "$SHELL")配置文件异常，请检查是否存在/可读写"
            ;;
        3)
            echo -e "\e[31m在 $HOME 下没有 .bashrc 或者 .zshrc 文件\e[0m"
            ;;
        4)
            echo "如果你正在使用其他的 shell(etc. fish), 请自行解决, 或者联系管理员"
            ;;
        *)
            echo -e "\e[31m[未知错误]\e[0m $error_code。"
            ;;
    esac

    # 根据具体情况决定是否退出
    exit "$error_code"
}
