<#
.SYNOPSIS
   比较两个文件的SHA256哈希值。
.DESCRIPTION
   此脚本接受两个文件路径作为参数，计算每个文件的SHA256哈希值，
   并输出文件是否相同的信息。
.PARAMETER FilePath1
   第一个文件的完整路径。
.PARAMETER FilePath2
   第二个文件的完整路径。
.EXAMPLE
   CompareFileHash.ps1 C:\path\to\file1 C:\path\to\file2
#>

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$FilePath1,
    
    [Parameter(Mandatory=$true, Position=1)]
    [string]$FilePath2
)

function Compare-FileHashes {
    param (
        [string]$File1,
        [string]$File2
    )

    # 计算第一个文件的哈希值
    try {
        $hash1 = Get-FileHash -Path $File1 -Algorithm SHA256
    }
    catch {
        Write-Warning "无法读取文件 '$File1'。错误：$($_.Exception.Message)"
        return
    }

    # 计算第二个文件的哈希值
    try {
        $hash2 = Get-FileHash -Path $File2 -Algorithm SHA256
    }
    catch {
        Write-Warning "无法读取文件 '$File2'。错误：$($_.Exception.Message)"
        return
    }

    # 比较哈希值
    if ($hash1.Hash -eq $hash2.Hash) {
        Write-Host "文件 '$File1' 和 '$File2' 的哈希值相同，文件一致。"
    } else {
        Write-Warning "文件 '$File1' 和 '$File2' 的哈希值不同，文件不一致。"
    }
}

# 主程序
Compare-FileHashes -File1 $FilePath1 -File2 $FilePath2