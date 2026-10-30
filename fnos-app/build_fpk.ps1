# 一键打包 ocr-fnos.fpk（需在已安装飞牛官方 fnpack 的环境运行）
$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pkgDir   = Join-Path $scriptDir "fpk\ocr-fnos"

if (-not (Get-Command fnpack -ErrorAction SilentlyContinue)) {
  Write-Host "[错误] 未检测到 fnpack 命令。"
  Write-Host "请先按官方文档安装飞牛打包工具：https://developer.fnnas.com/docs/guide"
  exit 1
}

Set-Location $pkgDir
Write-Host "=== 正在打包 $pkgDir ==="
fnpack build
Write-Host "=== 完成。生成的文件：==="
Get-ChildItem *.fpk -ErrorAction SilentlyContinue | ForEach-Object { Write-Host $_.Name }
