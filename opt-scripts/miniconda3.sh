#!/bin/bash

echo "sun2ot 定制版一键conda脚本 for nmu-whr 已启动, wait please..."

init_shell() {
  # if running bash  
  if [ -n "$BASH_VERSION" ]; then  
      # include .bashrc if it exists  
      if [ -f "$HOME/.bashrc" ]; then  
          # 初始化bash
          ~/miniconda3/bin/conda init bash
      fi  
  # if running zsh  
  elif [ -n "$ZSH_VERSION" ]; then  
      # include .zshrc if it exists  
      if [ -f "$HOME/.zshrc" ]; then  
          ~/miniconda3/bin/conda init zsh
      fi  
  else
      echo "No bash or zsh found. Can't initialize conda environment."
      exit 1
  fi  
}

remind() {
  echo "#############################"
  if [ -n "$BASH_VERSION" ]; then
    echo "Run \"source ~/.bashrc\" to activate the conda environment."
  elif [ -n "$ZSH_VERSION" ]; then
    echo "Run \"source ~/.zshrc\" to activate the conda environment."
  fi
  echo "#############################"
}

# 检查~/miniconda3路径是否存在，如果存在，则跳过安装
if [ -d "$HOME/miniconda3" ]; then
    echo "Miniconda3 already installed. Do you want to re-initialize the conda environment in your current shell (y/n)? "
    read -rp "Enter your choice: " user_response
    case $user_response in
        [Yy]*)
            # 初始化bash或zsh
            init_shell
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
else
    echo "Miniconda3 not found, starting installation..."

    # 建立miniconda3文件夹
    mkdir -p ~/miniconda3 || { echo "Failed to create directory."; exit 1; }

    # 下载安装脚本
    # wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh

    # 执行脚本并安装conda到~/miniconda3路径下
    # bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 || { echo "Miniconda3 installation failed."; exit 1; }
    bash /private/Miniconda3-latest-Linux-x86_64.sh -b -u -p ~/miniconda3 || { echo "Miniconda3 installation failed."; exit 1; }

    init_shell

    echo "Miniconda3 installation complete."

    remind
fi

if [ -f ~/.condarc ]; then
  echo "~/.condarc already exists. Skipping replacement."
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
    echo "\"~/.condarc\" has been replaced by Tsinghua mirrors successfully"
  else
    echo "Failed to replace \"~/.condarc\" with Tsinghua mirrors"
    exit 1
  fi
fi