#!/bin/bash

# 代理
function start_proxy() { /usr/local/script/proxy.sh; }

# 安装 miniconda3
function install_miniconda() { /usr/local/script/miniconda3.sh; }

# 切换 shell
function chsh-bash() { 
    chsh -s /bin/bash;
    cp /etc/skel/.bashrc /etc/skel/.bash_profile $HOME
}
function chsh-zsh() { /usr/local/script/chsh-zsh.sh; }

function exit_program() {
    echo "Bye 🛫"
    exit 0
}

# 显示菜单
function show_menu() {
    echo "---------"
    echo "   菜单   "
    echo "---------"
    echo
    echo "1. 启用代理"
    echo "2. 安装 miniconda"
    echo "3. 切换 bash"
    echo "4. 切换 zsh"
    echo "0. 退出"
    echo
    read -p "请输入一个选项（数字）：" option

    case $option in
        1)
            start_proxy
            ;;
        2)
            install_miniconda
            ;;
        3)
            chsh-bash
            ;;
        4)
            chsh-zsh
            ;;
        0)
            exit_program
            ;;
        *)
            echo "无效的选项"
            ;;
    esac

    show_menu
}

# 启动菜单
show_menu
