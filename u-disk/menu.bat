@echo off
setlocal enabledelayedexpansion

:menu
:: ��ʾ�˵�ѡ��
echo.
echo -----------------------------------------------------------
echo ��ѡ��Ҫ���е������
echo 1. Clash           2. Geek                 3. ͼ�ɹ�����
echo 4. ����������      5. C������              6. Win11����
echo 7. ���̷���        8. Win10�Ҽ��˵�        9. ��װRuntime
echo 11. wt.exe         12. pwsh
echo 0. �˳�
echo -----------------------------------------------------------
echo.

:: ��ȡ�û�����
set /p choice=����������ѡ��1-12����

:: �����û�����ִ�ж�Ӧ���
if "!choice!"=="1" (
    start   Archive\Software\clash\clash-verge-1.5.11-x64\Clash Verge.exe
) else if "!choice!"=="2" (
    start   Archive\Software\geek.exe
) else if "!choice!"=="3" (
    start   Ops\Debug\ͼ�ɹ�����202309\ͼ�ɹ�����2023.exe
) else if "!choice!"=="4" (
    start   Ops\Debug\360NetRepair\360safe\netmon\360NetRepair.exe
) else if "!choice!"=="5" (
    start   Ops\Debug\360CleanPro.exe
) else if "!choice!"=="6" (
    start   Ops\Debug\windows11��������_1.08beta_Զ����̳\Windows11��������.exe
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
    echo ��Ч��ѡ��������1-12֮������֡�
    goto menu
)

:: ����û�û��ѡ���˳����򷵻ز˵�
goto menu

:: �����ű�
endlocal
