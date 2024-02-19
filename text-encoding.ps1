# 输入路径、输出路径和编码格式
param(
    [string]$inPath,
    [string]$outPath,
    [string]$inEncoding,
    [string]$outEncoding
)

# 输入路径
if (-not $inPath) {
    $inPath = Read-Host "Please provide the input path"
}

# 检查输入路径
if (-not (Test-Path $inPath)) { Write-Error "Input path does not exist:$inPath" -ErrorAction Stop }

# 输出路径
if (-not $outPath) {
    Write-Host "No output path set, will use the same path as the input path!" -ForegroundColor Yellow
    $inFile = Get-ChildItem -Path $inPath
    $outPath = $inFile.FullName -replace $inFile.Extension,"_out$($inFile.Extension)"
} else {
    # 检查输出路径
    if (-not (Test-Path $outPath)) {
        Write-Host "Output path does not exist, attempting to create it..." -ForegroundColor Yellow
        try {
            New-Item -ItemType Directory -Path $outPath -ErrorAction Stop
            Write-Host "Output path created successfully!" -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to create output path: $_" -ErrorAction Stop
        }
    }
}

# 输入输出编码格式
if (-not $inEncoding) {
    $inEncoding = Read-Host "Input encoding"
}
if (-not $outEncoding) {
    $outEncoding = Read-Host "Output encoding"
}

# 读取输入编码的文本文件，并以输出编码保存到输出路径
Get-Content -Path $inPath -Encoding $inEncoding | Out-File -FilePath $outPath -Encoding $outEncoding

# 输出结果
Write-Host "File '$inPath' has been converted to '$outPath' with encoding '$outEncoding'" -ForegroundColor Green
