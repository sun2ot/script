@echo off
setlocal enabledelayedexpansion

:menu
:: 显示菜单选项
echo.
echo -----------------------------------------------------------
echo 请选择要运行的软件：
echo 1. Clash           2. Geek                 3. 图吧工具箱
echo 4. 断网急救箱      5. C盘清理              6. Win11设置
echo 7. 进程分析        8. Win10右键菜单        9. 安装Runtime
echo 11. wt.exe         12. pwsh
echo 0. 退出
echo -----------------------------------------------------------
echo.

:: 获取用户输入
set /p choice=请输入您的选择（1-12）：

:: 根据用户输入执行对应软件
if "!choice!"=="1" (
    start   Archive\Software\clash\clash-verge-1.5.11-x64\Clash Verge.exe
) else if "!choice!"=="2" (
    start   Archive\Software\geek.exe
) else if "!choice!"=="3" (
    start   Ops\Debug\图吧工具箱202309\图吧工具箱2023.exe
) else if "!choice!"=="4" (
    start   Ops\Debug\360NetRepair\360safe\netmon\360NetRepair.exe
) else if "!choice!"=="5" (
    start   Ops\Debug\360CleanPro.exe
) else if "!choice!"=="6" (
    start   Ops\Debug\windows11轻松设置_1.08beta_远景论坛\Windows11轻松设置.exe
) else if "!choice!"=="7" (
    start   Ops\Debug\ProcessExplorer\procexp64.exe
) else if "!choice!"=="8" (
    start   Ops\Debug\Win10-Context-Menu\ContextMenuManager.NET.4.0.exe
) else if "!choice!"=="9" (
    cmd /k runtime.bat
) else if "!choice!"=="11" (
    start   Ops\Terminal\terminal-1.19.10821.0\WindowsTerminal.exe
) else if "!choice!"=="12" (
    start   Ops\Terminal\PowerShell-7.4.2-win-x64\pwsh.exe
) else if "!choice!"=="0" (
    exit
) else (
    echo 无效的选择。请输入1-12之间的数字。
    goto menu
)

:: 如果用户没有选择退出，则返回菜单
goto menu

:: 结束脚本
endlocal
