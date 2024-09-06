#!/bin/bash

# 接受用户传入的安装路径，部署miniconda3

# 检查传参数量
if [ $# -ne 1 ]; then
    echo "Usage: $0 </absolute path/to/install/miniconda3>, the specified path not exists is ok, either."
    echo -e "\e[33m Watch out! The path should be end with 'miniconda3'."
    exit 1
fi

path="$1"

echo -e "\e[1m\e[32m sun2ot 定制版一键 conda 脚本 for nmu-whr 已启动, wait please..."

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
      echo -e "\e[31m You do not have any shell profiles such as .bashrc or .zshrc."
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
      echo -e "\e[31m No bash or zsh found. Change your shell first."
      exit 1
    fi
  fi
}


remind() {
  echo -e "\e[42m###########请看这里##################"
  if [[ $SHELL == *"/bash" ]]; then
    echo -e "\e[32m请执行 \"source ~/.bashrc\" 以激活conda环境!!!"
  elif [[ $SHELL == *"/zsh" ]]; then
    echo -e "\e[32m请执行 \"source ~/.zshrc\" 以激活conda环境!!!"
  fi
}

# 检查安装路径是否存在，如果存在，则跳过安装
if [ -d "$path" ]; then
    echo -e "\e[33mMiniconda3 already installed. Do you want to re-initialize the conda environment in your current shell (y/n)? "
    read -rp "Enter your choice: " user_response
    case $user_response in
        [Yy]*)
            # 初始化bash或zsh
            init_shell --init
            remind
            ;;
        [Nn]*)
            echo "Okay, nothing happened."
            ;;
        *)
            echo "Invalid response and nothing happened."
            echo "But I want you to input Yy/Nn next time, all right?"
            ;;
    esac
    exit 1
else
    echo "Miniconda3 not found, starting installation..."

    # just debug
    init_shell

    # 建立miniconda3文件夹
    mkdir -p $path || { echo "Failed to create directory."; exit 1; }

    # 下载安装脚本
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $path/miniconda.sh

    # 执行脚本并安装
    # bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 || { echo "Miniconda3 installation failed."; exit 1; }
    bash $path/miniconda.sh -b -u -p $path || { echo "Miniconda3 installation failed."; exit 1; }

    init_shell --init

    echo -e "\e[32mMiniconda3 installation complete."

    remind
fi

if [ -f ~/.condarc ]; then
  echo -e "\e[33m~/.condarc already exists. Skipping replacement."
else
  echo "Start replacing Conda sources with Tsinghua mirror sources..."
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
    echo -e "\e[32m\"~/.condarc\" has been replaced by Tsinghua mirrors successfully"
  else
    echo -e "\e[31mFailed to replace \"~/.condarc\" with Tsinghua mirrors"
    exit 1
  fi
fi