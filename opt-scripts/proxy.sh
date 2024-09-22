#!/bin/bash

# 向用户的shell配置文件开头写入两个函数：设置/取消设置 代理

# 检查当前用户的shell是否为bash
if [ -n "$SHELL" ] && [ "$(basename "$SHELL")" = "bash" ]; then
    shell_type="bash"
    rc_file=".bashrc"
else
    shell_type="zsh"
    rc_file=".zshrc"
fi

# 函数内容
ep_func() {
    export https_proxy="http://$PROXY:$CLASH_PORT" http_proxy="http://$PROXY:$CLASH_PORT" all_proxy="socks5://$PROXY:$CLASH_PORT"
    echo -e "\e[32m代理设置成功， mihomo 将在 $PROXY:$CLASH_PORT 为您服务^_^\e[0m"
    echo -e "\e[32m本次代理将消耗yzh的流量，请节省使用哦(ㆆᴗㆆ)\e[0m"
}

dp_func() {
    unset http_proxy https_proxy all_proxy
    echo -e "\e[32m代理取消成功^_^\e[0m"
}

if [ ! -f "$HOME/$rc_file" ] || [ ! -w "$HOME/$rc_file" ]; then
    echo "$HOME/$rc_file 不存在或不可写，代理设置失败 QAQ!"
    exit 1
fi

# 在rc文件开头添加函数定义
temp_file=$(mktemp)
proxy_config="# Proxy setup functions added by sun2ot script
PROXY=127.0.0.1
CLASH_PORT=7890
ep()
$(
    declare -f ep_func | tail -n +2
)
dp()
$(
    declare -f dp_func | tail -n +2
)"
echo "$proxy_config" > "$temp_file"
cat "$HOME/$rc_file" >> "$temp_file"
cp "$temp_file" "$HOME/$rc_file"
rm "$temp_file"

echo -e "\e[31m请注意：\e[0m"
echo -e "\e[33m1. 代理模块注入成功\e[0m"
echo -e "\e[33m2. 请手动执行 source $HOME/$rc_file\e[0m"
echo -e "\e[33m3. 执行 ep 开启代理，执行 dp 取消代理\e[0m"
echo -e "\e[33m4. 下次登录无需再次执行该步骤\e[0m"
