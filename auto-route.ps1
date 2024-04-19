# 定义要监控的网络接口名称和目标IP地址
$InterfaceName = "WLAN 2"
$TargetIpAddress = "172.16.16.242"
$SubnetMask = "32" # IP-CIDR格式，例如"24"或"32"

# 获取网络接口的信息
$Interface = Get-NetAdapter | Where-Object {$_.Name -eq $InterfaceName }

# 检查网络接口是否存在
if ($Interface) {
    # 获取网络接口的当前IP地址
    $CurrentIpAddress = (Get-NetIPAddress -InterfaceAlias $Interface.Name -AddressFamily IPv4).IPAddress

    # 检查是否获取到了IP地址
    if ($CurrentIpAddress) {
        # 删除旧的路由表条目（如果存在）
        Remove-NetRoute -DestinationPrefix $TargetIpAddress -Confirm:$false -ErrorAction SilentlyContinue

        # 添加新的路由表条目
        New-NetRoute -DestinationPrefix $TargetIpAddress/$SubnetMask -NextHop $CurrentIpAddress -InterfaceIndex $Interface.ifIndex -AddressFamily IPv4 -Verbose

        # 输出信息
        Write-Host "Add route for $($TargetIpAddress) success. Next hop is $($CurrentIpAddress)."
    } else {
        Write-Host "Can not get ip of $InterfaceName!"
    }
} else {
    Write-Host "找不到指定的网络接口: $InterfaceName"
}
