# 执行该脚本启动代理
# 注意：
# 1. 代理只对当前shell窗口生效，即用户重新登录后，不会默认激活代理
# 2. 在代理激活环境下的shell下启动的进程，退出登录后仍然具有代理环境
# 3. 如果启动代理后需要在不退出登录的情况下取消代理，请执行 stop_proxy.sh
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
if [ $? -eq 0 ]; then
    echo "代理设置成功, mihomo 将在 127.0.0.1:7890 为您服务^_^\n本次代理将消耗yzh的流量，请节省使用哦(ㆆᴗㆆ)"
else
    echo "代理设置失败, 请检查脚本捏:("
fi

ep() {
    export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
    if [ $? -eq 0 ]; then
        echo "代理设置成功, mihomo 将在 127.0.0.1:7890 为您服务^_^\n本次代理将消耗yzh的流量，请节省使用哦(ㆆᴗㆆ)"
    else
        echo "代理设置失败, 请检查脚本捏:("
    fi
}

