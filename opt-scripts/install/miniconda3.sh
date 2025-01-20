#!/bin/bash

# 接受用户传入的安装路径，部署miniconda3

# 导入依赖
source ../util/tips.sh

# 检查传参数量
if [ $# -ne 1 ]; then
    echo "Usage: $0 </absolute path/to/install/miniconda3>, the specified path not exists is ok, either."
    echo -e "\e[33mWatch out! The path should be end with 'miniconda3'.\e[0m"
    exit 1
fi

path="$1"

echo -e "\e[1m\e[32msun2ot 定制版一键 conda 脚本 for nmu-whr 已启动, wait please...\e[0m"

init_shell() {
  # 初始化标志
  local init_flag=${1:-}
  
  if [[ -n "$init_flag" ]] && [[ "$init_flag" == *"--init"* ]]; then
    # 执行conda初始化
    echo "Initializing conda environment..."
    # .bashrc exists
    if [[ $SHELL == *"/bash" ]]; then
      # 初始化bash
      $path/bin/conda init bash
    elif [[ $SHELL == *"/zsh" ]]; then
      # 初始化zsh
      $path/bin/conda init zsh
    else
      echo -e "\e[31m You do not have any shell profiles such as .bashrc or .zshrc.\e[0m"
      echo "If you use other shells(etc. fish), maybe you shoule contact the admin."
      exit 1
    fi
  else
    # 检查当前shell是否为bash或zsh
    if [[ $SHELL == *"/bash" ]]; then
      echo "Bash detected."
    elif [[ $SHELL == *"/zsh" ]]; then
      echo "Zsh detected."
    else
      echo -e "\e[31m No bash or zsh found. Change your shell first.\e[0m"
      exit 1
    fi
  fi
}


# 检查安装路径是否存在，如果存在，则跳过安装
if [ -d "$path" ]; then
    echo -e "\e[33m检测到 Miniconda3 已部署.\e[0m 是否需要 \e[33m重新启用\e[0m conda 环境 (y/n)? "
    read -rp "请选择(Y/y/N/n): " user_response
    case $user_response in
        [Yy]*)
            # 初始化bash或zsh
            init_shell --init
            remind
            ;;
        [Nn]*)
            echo "好的, 什么也没有发生."
            ;;
        *)
            echo "错误的选择, 所以什么也没有发生."
            echo "请输入 \e[32mY/y/N/n\e[0m, OK?"
            ;;
    esac
    exit 1
else
    echo "没有检测到 Miniconda3, 开始部署..."

    # just debug
    init_shell

    # 建立miniconda3文件夹
    mkdir -p $path || { echo -e "\e[31m创建路径失败.\e[0m"; exit 1; }

    # 下载安装脚本
    # wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $path/miniconda.sh
    wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $path/miniconda.sh

    # 执行脚本并安装
    bash $path/miniconda.sh -b -u -p $path || { echo -e "\e[31Miniconda3 安装失败.\e[0m"; exit 1; }

    init_shell --init

    echo -e "\e[32mMiniconda3 安装成功.\e[0m"

    remind
fi

if [ -f ~/.condarc ]; then
  echo -e "\e[33m~/.condarc 已存在.\e[0m"
else
  echo "开始配置 conda 清华镜像源..."
  tee ~/.condarc >/dev/null <<EOF
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  deepmodeling: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/
EOF
  # Check if .condarc has been replaced correctly
  if [ $? -eq 0 ]; then
    echo -e "\e[32m\"~/.condarc\" 已配置清华镜像!\e[0m"
  else
    echo -e "\e[31m配置 \"~/.condarc\" 清华镜像失败!\e[0m"
    exit 1
  fi
fi