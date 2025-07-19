# 获取用户输入路径
$basePath = Read-Host "请输入目标路径（支持使用 . 表示当前路径）"

# 将 . 转换为当前路径
if ($basePath -eq ".") {
    $basePath = $PWD.Path
} else {
    $basePath = [System.IO.Path]::GetFullPath($basePath)
}

# 获取用户输入的数字
do {
    $levelStr = Read-Host "请输入层级 n (1-4)"
    $n = [int]::Parse($levelStr)
} while ($n -lt 1 -or $n -gt 4)

# 生成所有组合路径
function Generate-Combinations {
    param (
        [int]$depth,
        [int]$maxLevel,
        [string]$currentPath,
        [string]$basePath
    )

    if ($depth -eq 0) {
        $fullPath = Join-Path $basePath $currentPath
        New-Item -Path $fullPath -ItemType Directory -Force | Out-Null
        return
    }

    for ($i = 1; $i -le $maxLevel; $i++) {
        $newPath = if ($currentPath) { Join-Path $currentPath $i } else { "$i" }
        Generate-Combinations -depth ($depth - 1) -maxLevel $maxLevel `
            -currentPath $newPath `
            -basePath $basePath
    }
}

# 开始生成文件夹
Generate-Combinations -depth $n -maxLevel $n -currentPath $null -basePath $basePath

Write-Host "文件夹已生成在: $basePath"
