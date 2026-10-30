#!/bin/bash
# 一键打包 ocr-fnos.fpk（需在已安装飞牛官方 fnpack 的环境运行）
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PKG_DIR="$SCRIPT_DIR/fpk/ocr-fnos"

if ! command -v fnpack >/dev/null 2>&1; then
  echo "[错误] 未检测到 fnpack 命令。"
  echo "请先按官方文档安装飞牛打包工具：https://developer.fnnas.com/docs/guide"
  exit 1
fi

cd "$PKG_DIR"
echo "=== 正在打包 $(pwd) ==="
fnpack build
echo "=== 完成。生成的文件：==="
ls -la *.fpk 2>/dev/null || echo "（若 fnpack 输出位置不同，请查看上方日志）"
