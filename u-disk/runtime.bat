@echo off
setlocal enabledelayedexpansion

:menu
:: 显示菜单选项
echo.
echo -----------------------------------------------------------
echo 请选择要安装的运行环境：
echo 1. VC运行库    2. Anaconda3    3. Git
echo 4. .NET8       5. .NET6        6. WPS VBA
echo 7. jdk17       8. Python3.10   9. vim
echo 10. 退出
echo -----------------------------------------------------------
echo.

:: 获取用户输入
set /p choice=请输入您的选择（1-10）：

:: 动态查找最新版本的软件路径
set "search_path=Ops\Runtime"
set "git_installer="
for /f "delims=" %%f in ('dir /b /od "%search_path%\Git-*-64-bit.exe"') do set "git_installer=%%f"

set "anaconda_installer="
for /f "delims=" %%f in ('dir /b /od "%search_path%\Anaconda3-*-Windows-x86_64.exe"') do set "anaconda_installer=%%f"

:: 根据用户输入执行对应操作
if "!choice!"=="1" (
    call    Ops\Runtime\VC-Runtime-All-in-One\install_all.bat
) else if "!choice!"=="2" (
    start   "%search_path%\!anaconda_installer!"
) else if "!choice!"=="3" (
    start   "%search_path%\!git_installer!"
) else if "!choice!"=="4" (
    start   Ops\Runtime\DotNet-desktop-runtime-8.0.1-win-x64.exe
) else if "!choice!"=="5" (
    start   Ops\Runtime\DotNet-desktop-runtime-6.0.26-win-x64.exe
) else if "!choice!"=="6" (
    start   Ops\Runtime\wps2019vba.exe
) else if "!choice!"=="7" (
    start   Ops\Runtime\jdk-17_windows-x64_bin.exe
) else if "!choice!"=="8" (
    start   Ops\Runtime\python-3.10.6-amd64.exe
) else if "!choice!"=="9" (
    start   Ops\Runtime\gvim_9.0.0000_x86_signed.exe
) else if "!choice!"=="10" (
    exit
) else (
    echo 无效的选择。请输入1-10之间的数字。
    goto menu
)

:: 如果用户没有选择退出，则返回菜单
goto menu

:: 结束脚本
endlocal
