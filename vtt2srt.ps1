<#
.SYNOPSIS
使用ffmpeg将当前路径下所有vtt字幕转换为srt格式。

.DESCRIPTION
输出文件名为 "原字幕名.srt"
#>

$vtts = Get-ChildItem -Path . -Filter "*.vtt"
foreach ($vtt in $vtts) {
    $srt = $vtt.Name -replace ".vtt", ".srt"
    & ffmpeg -i $vtt.Name $srt
}
