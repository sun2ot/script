#!/bin/bash

# 用户操作菜单

cmd="$1"

# 代理
function start_proxy() { /usr/local/script/proxy.sh; }

# 安装 miniconda3
function install_miniconda() { /usr/local/script/miniconda3.sh $HOME/miniconda3; }

# 安装 miniconda3 for AIOS
function install_miniconda_AIOS() {
    if [ ! -L $HOME/$USER ]; then
        echo "Call the admin to init your account!"
        exit 1
    else
        /usr/local/script/miniconda3.sh $HOME/$USER/miniconda3; 
    fi
}

# 切换 shell
function chsh-bash() { 
    chsh -s /bin/bash;
    cp /etc/skel/.bashrc /etc/skel/.bash_profile $HOME
    echo "##############################################"
    echo "The current shell has changed to \"bash\"."
    echo "Please run 'exit' to log out."
    echo "The shell change will effect on the next log in!"
    echo
    echo "当前shell已切换为\"bash\"."
    echo "请执行'exit'退出登录。"
    echo "下次登录时修改才会生效！"
    echo "##############################################"
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
    echo "Tips: 部分功能未完全测试，如有bug请及时反馈管理员。"
    echo
    echo "1. 启用代理"
    echo "2. 安装 miniconda"
    echo "3. 安装 miniconda for AIOS"
    echo "4. 切换 bash"
    echo "5. 切换 zsh"
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
            chsh-bash
            ;;
        5)
            chsh-zsh
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

# 显示管理员菜单
function show_admin_menu() {
    echo "----------"
    echo "   Admin  "
    echo "----------"
    echo "Warning: You have entered the administrator menu. Carefully!!"
    echo
    echo "1. Deploy/Update Starship"
    echo "0. Exit"
    echo
    read -p "Please choose an option (number): " option

    case $option in
        1)
            sudo curl -sS https://starship.rs/install.sh | sh
            ;;
        0)
            exit_program
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

# 启动菜单
if [ $# -eq 0 ]; then
    show_menu
elif [ $cmd == "--admin"* ]
    show_admin_menu
fi

