# 源文件夹路径
$sourceFolder = "E:\obsidian"

# 目标压缩包存储路径
$destinationFolder = "F:\Archive\obsidian"

# 获取当前日期时间并格式化为指定格式（例如：yyyyMMdd_HHmmss）
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# 压缩包文件名
$zipFileName = "Backup_$timestamp.zip"

# 使用.NET Framework中的System.IO.Compression.ZipFile类来创建压缩包
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourceFolder, "$destinationFolder\$zipFileName")

# Write-Host "$timestamp：备份完成，$zipFileName 已保存在 $destinationFolder"

# 获取目标路径下所有的zip文件
$zipFiles = Get-ChildItem -Path $destinationFolder -Filter "*.zip"

# 如果zip文件数量超过7个，则删除时间最早的zip文件，直到剩下7个为止
if ($zipFiles.Count -ge 8) {
    $oldestFiles = $zipFiles | Sort-Object CreationTime | Select-Object -First ($zipFiles.Count - 7)
    foreach ($file in $oldestFiles) {
        Remove-Item $file.FullName -Force
        # Write-Host "删除文件 $($file.FullName)"
    }
}
