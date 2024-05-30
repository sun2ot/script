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

function enable_go() {
    if [[ $SHELL == *"/bash" ]]; then
        echo "Bash detected."
        #! here is ', not "
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        profile='~/.bashrc'
    elif [[ $SHELL == *"/zsh" ]]; then
        echo "Zsh detected."
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
        profile='~/.zshrc'
    else
        echo "You do not have any shell profiles such as .bashrc or .zshrc."
        echo "If you use other shells(etc. fish), maybe you shoule contact the admin."
        exit 1
    fi
    
    echo "Go 1.21.10 has been deployed."
    echo "执行 \"source $profile\" 激活 Go 环境." 
}

function enable_java() {  
  if [[ $SHELL == *"/bash" ]]; then
    shell="$HOME/.bashrc"
  elif [[ $SHELL == *"/zsh" ]]; then
    shell="$HOME/.zshrc"
  else
    echo "You do not have any shell profiles such as .bashrc or .zshrc."
    echo "If you use other shells(etc. fish), maybe you shoule contact the admin."
    exit 1
  fi

  echo 'export JAVA_HOME=/opt/jdk-11.0.22' >> $shell
  echo 'export PATH=$JAVA_HOME/bin:$PATH' >> $shell
  echo 'export JRE_HOME=$JAVA_HOME/jre' >> $shell
  echo 'export CLASSPATH=.:$JAVA_HOME/lib' >> $shell
  
  echo "Jdk 11.0.22 has been deployed."
  echo "执行 \"source $shell\" 激活 Java 环境." 
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
    echo "6. 启用 Go(1.21.10) 环境"
    echo "7. 启用 Java-11.0.22 环境"
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
        6)
            enable_go
            ;;
        7)
            enable_java
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


# ---------------------------------------------------------------------- #

function mihomo() { /usr/local/script/mihomo.sh; }
function install_go() { /usr/local/script/go.sh; }
function install_java() { /usr/local/script/java.sh; }

# 显示管理员菜单
function show_admin_menu() {
    echo "----------"
    echo "   Admin  "
    echo "----------"
    echo "Warning: You have entered the administrator menu. Carefully!!"
    echo
    echo "1. Deploy/Update Starship"
    echo "2. Deploy mihomo"
    echo "3. Deploy Go"
    echo "4. Deploy Java"
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
elif [ $cmd == "--admin" ]; then
    show_admin_menu
fi

