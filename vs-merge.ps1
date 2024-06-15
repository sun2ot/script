<#
.SYNOPSIS
使用ffmpeg合并当前路径下所有mp4视频和srt字幕，并保存为mkv格式。

.DESCRIPTION
1. 默认视频和字幕文件名相同（除扩展外）
2. 输出文件名为 "原视频名.mkv"

.PARAMETER i
输入路径

.PARAMETER o
输出路径

.PARAMETER f
视频文件格式
#>

# 如果想在任意路径调用该脚本，请使用绝对路径导入该模块
Import-Module "E:\script\common.psm1" -DisableNameChecking

$params = Validate-Path

$videos = Get-ChildItem -Path $params['InputPath'] -Filter "*.$($params['Format'])"

foreach ($video in $videos) {
    $srt = $video.DirectoryName + $video.BaseName + ".srt"
    $out = $video.DirectoryName + $video.BaseName + ".mkv"
    & ffmpeg -i $video.FullName -i $srt -c copy -c:s srt $out
}
