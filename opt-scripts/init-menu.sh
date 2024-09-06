#!/bin/bash

# 准备执行menu.sh所需的前置脚本
# 注意，需在opt-scripts路径下执行该脚本

if [ -d "/usr/local/script" ]; then
    echo "/usr/local/script already exists."
else
    mkdir -p /usr/local/script
fi


# 定义链接脚本函数
link_to() {
    local target_path=$1
    local source_path=$2

    echo "----------"
    if [ -L "$target_path" ]; then
        echo -e "$target_path already exists. \e[31mDeleting...\e[0m"
        rm "$target_path"
    fi

    ln -s "$source_path" "$target_path"
    echo -e "$source_path \e[32mlinked to\e[0m $target_path"
    echo "----------"
    echo
}

# 脚本
scripts_to_link=("chsh-zsh.sh" "miniconda3.sh" "proxy.sh" "mihomo.sh" "go.sh" "java.sh" "node16.sh")
# shell配置文件
shell_profiles=(".bash_profile" ".zsh_profile")
# 配置文件
share_files=("starship.toml")

# 链接脚本
for script in "${scripts_to_link[@]}"; do
    script_path=$(realpath "$script")
    target_path="/usr/local/script/$script"
    link_to "$target_path" "$script_path"
done

# 链接骨架文件
for profile in "${shell_profiles[@]}"; do
    profile_path=$(realpath "$profile")
    target_path="/etc/skel/$profile"
    link_to "$target_path" "$profile_path"
done

# 链接配置文件
for profile in "${share_files[@]}"; do
    profile_path=$(realpath "$profile")
    target_path="/usr/local/share/$profile"
    link_to "$target_path" "$profile_path"
done

# 链接主菜单
if [ -L "/usr/local/bin/menu" ]; then
    echo -e "/usr/local/bin/menu already exists. \e[31mDeleting...\e[0m"
    rm /usr/local/bin/menu
    ln -s $(realpath menu.sh)  /usr/local/bin/menu
    echo -e "\e[32mmenu.sh re-linked.\e[0m"
else
    ln -s $(realpath menu.sh) /usr/local/bin/menu
    echo -e "\e[32mmenu.sh linked.\e[0m"
fi
