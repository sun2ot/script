function Validate-Path {
    # 验证输入路径、输出路径和视频文件格式
    param(
        [string]$i,
        [string]$o,
        [string]$f
    )
    
    # 输入路径
    if (-not $i) {
        $i = Read-Host "Please provide the input path"
    }

    # 检查输入路径
    if (-not (Test-Path $i)) { Write-Error "Input path does not exist:$i" -ErrorAction Stop }

    # 输出路径
    if (-not $o) {
        Write-Host "No output path set, will use the same path as the input path!" -ForegroundColor Yellow
        $o = $i
    } else {
        # 检查输出路径
        if (-not (Test-Path $o)) {
            Write-Host "Output path does not exist, attempting to create it..." -ForegroundColor Yellow
            try {
                New-Item -ItemType Directory -Path $o -ErrorAction Stop
                Write-Host "Output path created successfully!" -ForegroundColor Green
            }
            catch {
                Write-Error "Failed to create output path: $_" -ErrorAction Stop
            }
        }
    }

    # 视频文件格式
    # 无需判断是否合法，因为不合法时-Filter过滤不出任何内容
    if (-not $f) {
        Write-Host "No format set (e.g., mp4, mkv, etc.), will use 'mp4' as default!" -ForegroundColor Yellow
        $f = "mp4"
    }

    # # 输出获取到的参数
    # Write-Host "Input Path: $i"
    # Write-Host "Output Path: $o"
    # Write-Host "Format: $f"
    
    return @{
        i = $i
        o = $o
        f = $f
    }
}
