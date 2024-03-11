# 源文件夹路径
$sourceFolder = "D:\obsidian"

# 目标压缩包存储路径
$destinationFolder = "F:\share"

# 获取当前日期时间并格式化为指定格式（例如：yyyyMMdd_HHmmss）
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# 压缩包文件名
$zipFileName = "Backup_$timestamp.zip"

# 使用.NET Framework中的System.IO.Compression.ZipFile类来创建压缩包
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourceFolder, "$destinationFolder\$zipFileName")

Write-Host "$timestamp：备份完成，$zipFileName 已保存在 $destinationFolder"
