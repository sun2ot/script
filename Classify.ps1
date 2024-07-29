<#
.SYNOPSIS
分类当前路径下的零散文件，归纳到指定文件夹中

.DESCRIPTION
1. 文件     Documents
2. 程序     Programs
3. 压缩包   Compressed
#>

# 指定目标路径
# $docPath = "D:\Downloads\Documents"
# $proPath = "D:\Downloads\Programs"
# $compPath = "D:\Downloads\Compressed"

$docPath = "Documents"
$proPath = "Programs"
$compPath = "Compressed"

# 定义要移动的文件类型
$docTypes = @("*.doc", "*.docx", "*.pdf")
$proTypes = @("*.exe", "*.msi")
$compTypes = @("*.zip", "*.7z", "*.tar.gz")

# 获取并移动每种文件类型
foreach ($fileType in $docTypes) {
    Get-ChildItem -Path . -Filter $fileType | Move-Item -Destination $docPath
}

foreach ($fileType in $proTypes) {
    Get-ChildItem -Path . -Filter $fileType | Move-Item -Destination $proPath
}

foreach ($fileType in $compTypes) {
    Get-ChildItem -Path . -Filter $fileType | Move-Item -Destination $compPath
}
