# OCR 图片PDF转文字 · 飞牛 fnOS 应用（.fpk）

把 V1.1 的 OCR 网页工具打包成飞牛 fnOS 应用，可安装到 fnOS 应用中心，
并可上架到飞牛应用商店（官方应用中心 或 第三方 FN软仓）。

## 这个包做了什么
- 飞牛 fnOS 的 Docker 类应用，用官方 `nginx:alpine` 镜像托管 OCR 前端。
- **静态文件（html + libs）随包内置**，通过 `${TRIM_APPDEST}/docker/html` 挂载进容器。
- **无需自建镜像、无需注册 Docker Hub、无需推送仓库**——`.fpk` 本身约 43MB，完全自包含。
- 识别全程在用户浏览器里跑（pdf.js + tesseract.js），PDF 不上传任何服务器。

## 目录结构
```
fnos-app/
├── fpk/ocr-fnos/            # ★ .fpk 源码树（fnpack build 的输入）
│   ├── manifest             # 应用元数据（INI）
│   ├── ICON.PNG             # 64×64 图标
│   ├── ICON_256.PNG         # 256×256 图标
│   ├── config/
│   │   ├── privilege        # 运行身份（package）
│   │   └── resource         # 声明 docker-project
│   ├── app/
│   │   ├── docker/
│   │   │   ├── docker-compose.yaml   # 用 nginx:alpine，挂载 html 目录
│   │   │   └── html/                 # ★ OCR 前端（index.html + libs/）
│   │   └── ui/
│   │       ├── config                 # 桌面入口（iframe 指向 8080）
│   │       └── images/icon_*.png      # 入口图标
│   ├── cmd/main             # 生命周期（status 检查容器）
│   └── wizard/              # 安装向导（本应用无需配置，留空）
├── build_fpk.sh / .ps1      # 一键打包（调用 fnpack build）
└── README_fnos.md           # 本文件
```

## 前置条件
- 一台能跑 `fnpack` 的机器（Windows / macOS / Linux 均可，不一定需要 fnOS 本机）。
- 安装飞牛官方打包工具 **fnpack**：参考 https://developer.fnnas.com/docs/guide
- 能访问 Docker Hub（`nginx:alpine` 由 fnOS 在 NAS 上自动拉取，无需你推送）。

## 步骤一：打包成 .fpk
```bash
# 在 fnos-app/ 目录下
bash build_fpk.sh      # 或 Windows 上用 PowerShell 运行 build_fpk.ps1
```
成功后会在 `fpk/ocr-fnos/` 下生成 **`ocr-fnos.fpk`**。

> 若不想用脚本，也可以手动：
> ```bash
> cd fnos-app/fpk/ocr-fnos
> fnpack build
> ```

## 步骤二（建议先做）：本地实测
1. 打开飞牛 fnOS → 应用中心 → 找到「手动安装 / 上传 .fpk」。
2. 上传刚生成的 `ocr-fnos.fpk`，按提示安装。
3. 安装完成后，应用卡片点击「打开」应能进入 OCR 页面。
4. 拖入一个图片型 PDF，确认能识别、能导出。

## 步骤三：上架到应用商店
`.fpk` 准备就绪后，有两种上架路径：

### 路径 A：官方应用中心（审核较严）
1. 飞牛官方「应用中心开发者先锋交流群」申请成为开发者（文档见
   https://developer.fnnas.com/docs/guide ，也可在飞牛论坛/粉丝群联系社区主理人）。
2. 按官方要求提交 `.fpk` + 应用截图 + 图标。
3. 等待审核通过后，所有 fnOS 用户可在应用中心搜到并安装。

### 路径 B：FN软仓 · 第三方应用商店（更简单，推荐先走这条）
FN软仓是官方应用中心之外的第三方商店，已有上百款三方应用，提交门槛低：
- 方式①：把 `ocr-fnos.fpk` + 截图发给 FN软仓 管理员（QQ 群 / 论坛帖附件），帮你上架官方源。
- 方式②：填写 WPS 表单提交应用信息 + `.fpk` 直链。
- 方式③：把 `.fpk` 传 Gitee/GitHub Release，提供 raw / release 直链即可（服务端 302 跳转，不占管理员磁盘）。
- 征集帖与建源文档：https://club.fnnas.com/forum.php?mod=viewthread&tid=74117
- 服务端镜像：`ccr.ccs.tencentyun.com/hhxs2025/fn-appstores-server`（想自建源用）

## 自定义（上架前建议改这几处）
- `fpk/ocr-fnos/manifest`：
  - `maintainer` / `distributor`：改成你的名字或团队。
  - `display_name`：应用显示名（已默认「OCR 图片PDF转文字」）。
  - `appname`：唯一标识，保持 `ocr-fnos` 即可，若与其他包冲突再改。
  - `os_min_version`：按你实测过的最低 fnOS 版本填（默认 1.2.0）。
- `fpk/ocr-fnos/app/docker/html/index.html`：就是 OCR V1.1 本体，后续升级改这里即可。
- 升级版本：改 `manifest` 的 `version`（必须 X.Y.Z），重新 `fnpack build`。

## 常见问题排查
- **入口打不开**：确认 `manifest.service_port`(8080)、`docker-compose.yaml` 的
  `${TRIM_SERVICE_PORT}:80`、以及 `app/ui/config` 里入口的 `port`(8080) 三者一致。
- **状态一直“未运行”**：确认 `cmd/main` 里的 `CONTAINER_NAME`(ocr-fnos-web) 与
  compose 里的 `container_name` 一致。
- **nginx 起不来 / 页面空白**：确认 `app/docker/html/index.html` 与 `libs/` 已随包正确打包
  （解压 .fpk 后应有这些文件）。
- **中文 PDF 导出乱码**：V1.1 已内嵌中文字体，正常情况下不应出现；若异常请核对
  `libs/DroidSansFallbackFull.ttf` 是否在包内。

## 备注
- 本应用 100% 前端运行，NAS 仅作“静态网页托管”，不消耗 NAS 算力做 OCR。
- 首次识别会在浏览器内加载语言包（已随包内置，无需联网）。
- 若你希望**镜像自包含**（不把 43MB 放进 .fpk，而是打成独立 Docker 镜像），
  可改用 `image: 你的仓库/ocr-fnos:1.1.0` 并用 Dockerfile 把 html/libs 烤进镜像，
  再 `docker push` 到公开仓库——但通常挂载方案更省事，故本包默认采用挂载方案。
