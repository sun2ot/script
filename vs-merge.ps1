<#
.SYNOPSIS
使用ffmpeg合并当前路径下所有mp4视频和srt字幕，并保存为mkv格式。

.DESCRIPTION
1. 默认视频和字幕文件名相同（除扩展外）
2. 输出文件名为 "原视频名.mkv"
#>

$videos = Get-ChildItem -Path . -Filter "*.mp4"
foreach ($video in $videos) {
    $name = $video.BaseName
    $srt = $name + ".srt"
    $out = $name + ".mkv"
    & ffmpeg -i $video.Name -i $srt -c copy -c:s srt $out
}
