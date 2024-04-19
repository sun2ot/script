#!/bin/bash

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
    export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
    echo "代理设置成功， mihomo 将在 127.0.0.1:7890 为您服务^_^\n本次代理将消耗yzh的流量，请节省使用哦(ㆆᴗㆆ)"
}

dp_func() {
    unset http_proxy https_proxy all_proxy
    echo "代理取消成功^_^"
}

if [ ! -f "$HOME/$rc_file" ] || [ ! -w "$HOME/$rc_file" ]; then
    echo "$HOME/$rc_file 不存在或不可写，代理设置失败 QAQ!"
    exit 1
fi

# 在rc文件开头添加函数定义
temp_file=$(mktemp)
proxy_config="# Proxy setup functions added by sun2ot script
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

echo "#######################################"
echo "1. 代理模块注入成功"
echo "2. 请按0退出脚本，然后手动执行 source $HOME/$rc_file"
echo "3. 下次登录无需再次启用代理，只需执行 ep 开启代理，执行 dp 取消代理"
echo "#######################################"

# 重新加载配置文件
if [ "$shell_type" = "bash" ]; then
    source "$HOME/$rc_file"
else
    exec zsh -l -c "source $HOME/$rc_file"
fi
