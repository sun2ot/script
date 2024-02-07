<#
.SYNOPSIS
使用ffmpeg裁剪输入路径下所有指定格式视频的开头0.5s，并保存到输出路径。

.DESCRIPTION
通过裁剪极短时间的视频内容，起到修改文件签名的效果，从而实现网盘防和谐。

.PARAMETER i
输入视频的所在路径

.PARAMETER o
输出路径

.PARAMETER f
视频文件格式，如 mp4, mkv, avi 等。
#>

param(
    [string]$i,
    [string]$o,
    [string]$f
)

$ErrorActionPreference = "Stop"

# 必选参数
if (-not $i) {
    $i = Read-Host "Please provide the input path"
}

# 检查输入路径
if (-not (Test-Path $i)) {
    Write-Error "Input path does not exist: $i"
    exit 1
}

# 可选参数
if (-not $o) {
    Write-Host "No output path set, will use current directory as default!"
    $o = "."
}

# 检查输出路径
if (-not (Test-Path $o)) {
    Write-Host "Output path does not exist, creating it automatically!"
    New-Item -ItemType Directory -Path $o
}

if (-not $f) {
    Write-Host "No format set (e.g., mp4, mkv, etc.), will use 'mp4' as default!"
    $f = "mp4"
}

try {
    $vlist = Get-ChildItem -Path $i -Filter "*.$f"
    foreach ($video in $vlist) {
        $filename = $video.FullName
        $out = "$o\$($video.BaseName)_out.$f"
        Write-Host "Cutting '$filename' to '$out'"
        & ffmpeg -i $filename -ss 00:00:00.500 -c copy $out
    }
} catch {
    Write-Error "$_"
}
