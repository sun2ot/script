## Introduction

一个脚本仓库，目前多为powershell脚本，用于处理视频

## 推荐食用方式

`git clone`，然后将路径添加到 `Path` 环境变量。

可以添加一个自定义 powershell 函数 `script` 以提供辅助信息：

```powershell
function script{ 
    Set-Location -Path "D:\script"; Get-ChildItem -Path "D:\script" -Filter "*.ps1"
}
```

然后可以通过如下指令使用：

```powershell
# 查看当前脚本
script
# 调用脚本
fcut_all
```