@echo off
setlocal enabledelayedexpansion

:menu
:: ��ʾ�˵�ѡ��
echo.
echo -----------------------------------------------------------
echo ��ѡ��Ҫ��װ�����л�����
echo 1. VC���п� ^t 2. Anaconda3 ^t 3. Git
echo 4. .NET8 ^t 5. .NET6 ^t 6. WPS VBA
echo 7. jdk17 ^t 8. Python3.10 ^t 9. vim
echo 10. �˳�
echo -----------------------------------------------------------
echo.


:: ��ȡ�û�����
set /p choice=����������ѡ��1-10����

:: �����û�����ִ�ж�Ӧ����
if "!choice!"=="1" (
    call   Ops\Runtime\VC-Runtime-All-in-One-Feb-2024\install_all.bat
) else if "!choice!"=="2" (
    start   Ops\Runtime\Anaconda3-2024.02-1-Windows-x86_64.exe
) else if "!choice!"=="3" (
    start   Ops\Runtime\Git-2.44.0-64-bit.exe
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
    echo ��Ч��ѡ��������1-10֮������֡�
    goto menu
)

:: ����û�û��ѡ���˳����򷵻ز˵�
goto menu

:: �����ű�
endlocal
