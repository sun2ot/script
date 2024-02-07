<#
.SYNOPSIS
使用ffmpeg裁剪输入路径下所有指定格式视频的开头0.5s，并保存到输出路径。

.DESCRIPTION
通过裁剪极短时间的视频内容，起到修改文件签名的效果，从而实现网盘防和谐。

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

Import-Module "D:\script\common.psm1" -DisableNameChecking

# 调用函数并获取返回结果
$params = Validate-Path -i $i -o $o -f $f

# 输出获取到的参数
# Write-Host "Input Path: $($params.i)"
# Write-Host "Output Path: $($params.o)"
# Write-Host "Format: $($params.f)"


try {
    $vlist = Get-ChildItem -Path $($params.i) -Filter "*.$($params.f)"
    foreach ($video in $vlist) {
        $filename = $video.FullName
        $out = "$($params.o)\$($video.BaseName)_out.$($params.f)"
        Write-Host "Cutting '$filename' to '$out'" -ForegroundColor Green
        & ffmpeg -i $filename -ss 00:00:00.500 -c copy $out
    }
} catch {
    Write-Error "$_"
}
