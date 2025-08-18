param(
    [Parameter(Position=0)]
    [string]$Path = "."
)

function Format-Size {
    param([long]$bytes)
    if ($bytes -ge 1TB) {
        return "{0:N2} TB" -f ($bytes / 1TB)
    } elseif ($bytes -ge 1GB) {
        return "{0:N2} GB" -f ($bytes / 1GB)
    } elseif ($bytes -ge 1MB) {
        return "{0:N2} MB" -f ($bytes / 1MB)
    } elseif ($bytes -ge 1KB) {
        return "{0:N2} KB" -f ($bytes / 1KB)
    } else {
        return "$bytes B"
    }
}

# 解析并检查路径
try {
    $resolved = Resolve-Path -Path $Path -ErrorAction Stop
} catch {
    Write-Error "路径不存在： $Path"
    exit 1
}

$targetPath = $resolved.Path

# 如果是文件，则只输出该文件大小；如果是目录，则列出其下的每个子项
$item = Get-Item -LiteralPath $targetPath -ErrorAction Stop

function Get-SizeBytesForItem {
    param($itm)
    if ($itm.PSIsContainer) {
        try {
            # 递归统计目录下所有文件大小（忽略访问错误）
            $sum = (Get-ChildItem -LiteralPath $itm.FullName -Recurse -File -ErrorAction SilentlyContinue |
                    Measure-Object -Property Length -Sum).Sum
            if (-not $sum) { $sum = 0 }
        } catch {
            $sum = 0
        }
    } else {
        $sum = $itm.Length
    }
    return [long]$sum
}

# 输出单个文件或目录下每个子项
if (-not $item.PSIsContainer) {
    $bytes = Get-SizeBytesForItem -itm $item
    $hr = Format-Size $bytes
    Write-Output ("{0}`t{1}" -f $hr, $item.FullName)
} else {
    $children = Get-ChildItem -LiteralPath $item.FullName -Force:$false -ErrorAction SilentlyContinue
    if (-not $children) {
        Write-Output ("{0}`t{1}" -f (Format-Size 0), $item.FullName)
        return
    }

    foreach ($c in $children) {
        $bytes = Get-SizeBytesForItem -itm $c
        $hr = Format-Size $bytes
        Write-Output ("{0}`t{1}" -f $hr, $c.FullName)
    }
}
