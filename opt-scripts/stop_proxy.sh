# 执行该脚本以取消当前shell窗口的代理环境
unset http_proxy https_proxy all_proxy
if [ $? -eq 0 ]; then
    echo "代理取消成功^_^"
else
    echo "代理取消失败, 请检查脚本捏:("
fi

## 定义函数dp(disable proxy)，执行source ~/env/stop_proxy.sh
dp() {
    unset http_proxy https_proxy all_proxy
    if [ $? -eq 0 ]; then
        echo "代理取消成功^_^"
    else
        echo "代理取消失败, 请检查脚本捏:("
    fi
}