#!/bin/bash

# 用户操作菜单

# 引入依赖
source /usr/local/script/util/error_handler.sh
source /usr/local/script/util/tips.sh
source /usr/local/script/util/detect_shell.sh


cmd="$1"

# 代理
function start_proxy() { /usr/local/script/config/proxy.sh; }

# 安装 miniconda3
function init_conda_shell() { /usr/local/script/util/init-conda.sh; }

# 切换 shell
function chsh_bash() { 
    chsh -s /bin/bash;
    cp /etc/skel/.bashrc /usr/local/script/config/.bash_profile $HOME
    next_login
}
function chsh-zsh() { /usr/local/script/install/chsh-zsh.sh; }

function exit_program() {
    echo "Bye 🛫"
    exit 0
}

function deploy_pixi() {
    echo "正在部署 pixi..."
    curl -fsSL https://pixi.sh/install.sh | sh
}

# 显示菜单
function show_menu() {
    echo "---------"
    echo "   菜单   "
    echo "---------"
    echo "Tips: 部分功能未完全测试，如有 bug 请及时反馈管理员。"
    echo
    echo "1. 启用代理"
    echo "2. 切换 bash"
    echo "3. 切换 zsh"
    echo "4. 激活 conda 环境"
    echo "5. 部署 pixi"
    echo "0. 退出"
    echo
    read -p "请输入一个选项（数字）：" option

    case $option in
        1)
            start_proxy
            ;;
        2)
            chsh_bash
            ;;
        3)
            chsh-zsh
            ;;
        4)
            init_conda_shell
            ;;
        5)
            deploy_pixi
            ;;
        0)
            exit_program
            ;;
        *)
            echo "无效的选项"
            ;;
    esac

    # The menu should not be showed repeatedly, because always have silly boys which can not see the logs. 
    # show_menu
}


# 启动菜单
if [ $# -eq 0 ]; then
    show_menu
fi