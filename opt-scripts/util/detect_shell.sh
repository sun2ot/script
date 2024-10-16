#!/bin/sh

detect_shell() {
    # 检测当前用户的登录shell
    current_shell=$(echo $SHELL)

    # 使用通配符匹配不同的shell
    if [[ "$current_shell" == *"/bash" ]]; then
        echo "$HOME/.bashrc"
    elif [[ "$current_shell" == *"/zsh" ]]; then
        echo "$HOME/.zshrc"
    else
        echo "-1"
    fi
}
