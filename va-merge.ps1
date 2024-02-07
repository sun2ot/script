<#
.SYNOPSIS
使用ffmpeg合并当前路径下所有mp4视频和m4a音频

.DESCRIPTION
1. 默认视频和音频文件名相同（除扩展外）
2. 输出文件名为 "原视频名_out.mp4"
#>

$vlist = Get-ChildItem -Name -Path . -Filter *.mp4
foreach ($video in $vlist) {
    $filename=$video.BaseName
    $au_name=$filename+".m4a"
    $out="out/"+$filename+"_out.mp4"
    & ffmpeg -i $video -i $au_name -c:v copy -c:a copy $out
}
pause
