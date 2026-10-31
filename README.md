# OCR 图片型 PDF 转文字工具（离线版）

纯前端、本地运行、无需联网。把"由图片构成的 PDF"（扫描件、影印件、发票等）
拖进网页，自动逐页识别成可编辑文字，支持批量处理与多格式导出。

## 包含版本
- `index.html` —— 主程序入口（与 `ocr-v1.1.html` 内容一致，作为默认首页）
- `ocr-v1.1.html` —— 主程序：离线 + 批量 + 倾斜校正 + 颜色校正 + 多格式导出
- `ocr-v1.0.html` —— 早期在线版（单文件，依赖 CDN，仅作备份保留）
- `libs/` —— 离线依赖（pdf.js、tesseract.js + wasm 核心、jsPDF、中文字体、语言包）
- `启动本地服务.bat` —— 一键启动本地服务并打开网页
- `fnos-app/` —— 飞牛 fnOS 应用打包脚本（`build_fpk.sh` / `build_fpk.ps1`，说明见 `README_fnos.md`）

## 快速使用
1. 把整个文件夹解压到任意位置（路径不要含中文/空格以外的特殊字符更好）。
2. **双击 `启动本地服务.bat`**，它会自动起一个本地服务并用浏览器打开。
3. 将图片型 PDF 拖入网页（可一次多个）→ 选择识别语言 / 清晰度 / 预处理选项 →
   点"开始识别（全部）"。
4. 识别完成后，勾选需要的文件，选导出格式（Word / HTML / 可编辑 PDF），点"导出选中"。

> ⚠️ 请勿直接双击 `ocr-v1.1.html` 以 `file://` 方式打开：
> Chrome 会拦截 OCR 的 Worker / WASM，导致识别失败。Firefox 通常可直接打开。
> 用 `启动本地服务.bat` 是最稳妥的方式（需要本机已安装 Python 或 Node.js）。

## 功能说明
- **可离线**：全部依赖已本地化，断网也能用。
- **批量**：一次拖入多个 PDF，逐个识别并显示总进度。
- **倾斜校正**：自动检测并旋转 -10°~10° 的扫描歪斜。
- **颜色校正**：灰度化 / Otsu 二值化（黑白）/ 亮度对比度调整，处理前有实时预览。
- **多格式导出**：
  - Word（`.doc`，可在 Word 中编辑）
  - HTML（独立网页）
  - 可编辑 PDF（jsPDF 写入真实文字层，文字可选中/复制，已内嵌中文字体）

## 识别语言
中文 + 英文 / 仅中文 / 仅英文 / 繁体 + 英文。

## 准确率提示
打印体、发票、清晰扫描件效果好；手写体、严重倾斜或低分辨率图片准确率有限
（属 OCR 引擎本身限制，预处理校正可提升一部分）。

## 从 GitHub 获取
**方式一（推荐）**：到 [Releases](https://github.com/szboboxing/ocr-web/releases) 页面下载
`OCR-Offline-Tool-v1.1.zip`（37 MB，含全部离线依赖），解压即用，无需克隆仓库。

**方式二**：克隆源码仓库（适合开发者）：
```bash
git clone https://github.com/szboboxing/ocr-web.git
cd ocr-web
# Windows: 双击 启动本地服务.bat
# macOS / Linux: cd 到本目录后执行 python3 -m http.server 8000
```

## 系统要求
- Windows（推荐 Chrome / Edge / Firefox 浏览器）
- 本机有 Python 3 或 Node.js（用于 `启动本地服务.bat`；也可手动启动任意静态服务）
- 首次识别会在本地加载语言包，稍候片刻即可。

## License

[MIT](./LICENSE) © 2026 boboxing
