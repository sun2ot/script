#!/bin/bash

# 用户操作菜单

# 引入依赖
source /usr/local/script/util/error_handler.sh
source /usr/local/script/util/tips.sh
source /usr/local/script/util/detect_shell.sh


cmd="$1"

# 代理
function start_proxy() { source $proxy; }

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

function enable_go() {
    profile=$(detect_shell)
    if [ detect_shell = "-1" ]; then
        error_handler 3; error_handler 4
        exit 1
    fi
    echo 'export PATH=$PATH:/usr/local/go/bin' >> $profile
    echo "Go 1.21.10 has been deployed."
    remind
}

function enable_java() {  
    profile=$(detect_shell)
    if [ detect_shell = "-1" ]; then
        error_handler 3; error_handler 4
        exit 1
    fi

    echo 'export JAVA_HOME=/opt/jdk-11.0.22' >> $profile
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> $profile
    echo 'export JRE_HOME=$JAVA_HOME/jre' >> $profile
    echo 'export CLASSPATH=.:$JAVA_HOME/lib' >> $profile
    echo "Jdk 11.0.22 has been deployed."
    remind
}


function enable_nodejs18() {  
    profile=$(detect_shell)
    if [ detect_shell = "-1" ]; then
        error_handler 3; error_handler 4
        exit 1
    fi

    echo 'export PATH=/usr/local/node-v18.20.2-linux-x64/bin:$PATH' >> $profile

    echo "Node.js 18 LTS has been deployed."
    remind
}

function enable_nodejs16() {  
    profile=$(detect_shell)
    if [ detect_shell = "-1" ]; then
        error_handler 3; error_handler 4
        exit 1
    fi

    echo 'export PATH=/opt/node-v16.20.2-linux-x64/bin:$PATH' >> $profile

    echo "Node.js 16 LTS has been deployed."
    remind
}

# 切换 shell
function chsh_bash() { 
    chsh -s /bin/bash;
    cp /etc/skel/.bashrc config/.bash_profile $HOME
    next_login
}
function chsh-zsh() { /usr/local/script/install/chsh-zsh.sh; }

function feedback() {
    read -p "你想对管理员说：" msg

    # 构建JSON消息体
    json_msg=$(printf '{"msgtype": "text", "text": {"content": "%s"}}' "$msg")

    token=""
    if [ -f "wx_hook_key" ]; then
        # 不要乱用我的 token 哦🔪🩸
        token=$(cat /usr/local/script/config/wx_hook_key)
    else
        echo "No token found. Please check the file 'wx_hook_key'."
        exit 1
    fi

    curl "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=$token" \
    -H 'Content-Type: application/json' \
    -d "$json_msg"
}

function exit_program() {
    echo "Bye 🛫"
    exit 0
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
    echo "6. 启用 Go(1.21.10) 环境"
    echo "7. 启用 Java-11.0.22 环境"
    echo "8. 启用 Node.js 18 LTS 环境(适用于物理机)"
    echo "9. 启用 Node.js 16 LTS 环境(适用于AIOS)"
    echo "00. 反馈 bug"
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
            enable_go
            ;;
        7)
            enable_java
            ;;
        8)
            enable_nodejs18
            ;;
        9)
            enable_nodejs16
            ;;
        0)
            exit_program
            ;;
        00)
            feedback
            ;;
        *)
            echo "无效的选项"
            ;;
    esac

    # The menu should not be showed repeatedly, because always have silly boys which can not see the logs. 
    # show_menu
}


#* ---------------------------------------------------------------------- *#

function mihomo() { /usr/local/script/extract/mihomo.sh; }
function install_go() { /usr/local/script/extract/go.sh; }
function install_java() { /usr/local/script/extract/java.sh; }
function install_nodejs16() { /usr/local/script/extract/node16.sh; }
function install_mamba() {
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    bash Miniforge3-$(uname)-$(uname -m).sh
}

# 显示管理员菜单
function show_admin_menu() {
    echo "----------"
    echo "   Admin  "
    echo "----------"
    echo -e "\e[33mWarning: You have entered the administrator menu. Carefully!!\e[0m"
    echo
    echo "1. Deploy/Update Starship (recommended with proxy)"
    echo "2. Deploy mihomo"
    echo "3. Deploy Go"
    echo "4. Deploy Java"
    echo "5. Deploy Node.js 16 (for AIOS)"
    echo "6. Install mamba"
    echo "0. Exit"
    echo
    read -p "Please choose an option (number): " option

    case $option in
        1)
            sudo curl -sS https://starship.rs/install.sh | sh
            ;;
        2)
            mihomo
            ;;
        3)
            install_go
            ;;
        4)
            install_java
            ;;
        5)
            install_nodejs16
            ;;
        6)
            install_mamba
            ;;
        0)
            exit_program
            ;;
        *)
            echo "\e[31mInvalid option\e[0m"
            ;;
    esac
}

# 启动菜单
if [ $# -eq 0 ]; then
    show_menu
elif [ $cmd == "--admin" ]; then
    show_admin_menu
fi

