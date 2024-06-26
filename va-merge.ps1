<#
.SYNOPSIS
使用ffmpeg合并当前路径下所有视频和m4a音频

.DESCRIPTION
1. 默认视频和音频文件名相同（除扩展外）
2. 输出文件名为 "原视频名_out"

.PARAMETER i
输入路径

.PARAMETER o
输出路径

.PARAMETER f
视频文件格式
#>

param(
    [string]$i,
    [string]$o,
    [string]$f
)

# 如果想在任意路径调用该脚本，请使用绝对路径导入该模块
Import-Module "E:\script\common.psm1" -DisableNameChecking

$params = Validate-Path -i $i -o $o -f $f

$videos = Get-ChildItem -Path $($params.i) -Filter "*.$($params.f)"

foreach ($video in $videos) {
    $au_name = $video.FullName -replace $params.f,"m4a"
    #$out = "$($params.o)\$($video.BaseName)_out.$($params.f)"
    $out = "$($params.o)\$($video.BaseName)_out.mp4"
    & ffmpeg -i $video.FullName -i $au_name -c:v copy -c:a copy $out
}
pause
