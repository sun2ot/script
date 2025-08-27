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
function install_miniconda() { /usr/local/script/install/miniconda3.sh $HOME/miniconda3; }

# 安装 miniconda3 for AIOS
function install_miniconda_AIOS() {
    if [ ! -L $HOME/$USER ]; then
        echo -e "\e[31m请联系管理员对你的账户进行初始化! 或者当前计算节点不属于 AIOS!"
        exit 1
    else
        /usr/local/script/install/miniconda3.sh $HOME/$USER/miniconda3; 
    fi
}

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

# 新增配置 TeX Live 环境变量
function config_latex() { /usr/local/script/config/latex.sh; }

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
    echo "2. 安装 miniconda"
    echo "3. 安装 miniconda for AIOS"
    echo "4. 切换 bash"
    echo "5. 切换 zsh"
    echo "6. 配置 TeX Live 环境变量"
    echo "7. 部署 pixi"
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
            install_miniconda_AIOS
            ;;
        4)
            chsh_bash
            ;;
        5)
            chsh-zsh
            ;;
        6)
            config_latex
            ;;
        7)
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