#!/bin/bash

echo "sun2ot 定制版一键conda脚本 for nmu-whr 已启动, wait please..."

# 检查~/miniconda3路径是否存在，如果存在，则跳过安装
if [ -d "$HOME/miniconda3" ]; then
    echo "Miniconda3 already installed. If you really want to init miniconda3, delete \"~/miniconda3\" and run script again!"
    exit 1
else
    echo "Miniconda3 not found, starting installation..."

    # 建立miniconda3文件夹
    mkdir -p ~/miniconda3 || { echo "Failed to create directory."; exit 1; }

    # 下载安装脚本
    # wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh

    # 执行脚本并安装conda到~/miniconda3路径下
    # bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 || { echo "Miniconda3 installation failed."; exit 1; }
    bash /private/Miniconda3-latest-Linux-x86_64.sh -b -u -p ~/miniconda3 || { echo "Miniconda3 installation failed."; exit 1; }

    # 初始化bash
    ~/miniconda3/bin/conda init bash
fi

echo "Miniconda3 installation complete."
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

# 检查.condarc是否已正确更新
if [ $? -eq 0 ]; then
    echo "\"~/.condarc\" has been replaced by Tsinghua mirrors successfully"
else
    echo "Failed to replace \"~/.condarc\" with Tsinghua mirrors"
    exit 1
fi

echo "---------------------------------"
echo "Run \"source ~/.bashrc\" to activate the conda environment."
