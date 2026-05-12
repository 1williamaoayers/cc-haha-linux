# Claude Code Haha (Linux Headless & H5 Edition)

<p align="center">
  <img src="docs/images/app-icon.png" alt="Claude Code Haha" width="240">
</p>

<div align="center">

[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/1williamaoayers/cc-haha-linux/release-desktop.yml?style=social)](https://github.com/1williamaoayers/cc-haha-linux/actions)
[![License](https://img.shields.io/github/license/NanmiCoder/cc-haha)](https://github.com/1williamaoayers/cc-haha-linux/blob/main/LICENSE)
[![中文](https://img.shields.io/badge/🇨🇳_中文-当前-blue)](README.md)
[![English](https://img.shields.io/badge/🇺🇸_English-Available-green)](README.en.md)

</div>

**本项目是 [NanmiCoder/cc-haha](https://github.com/NanmiCoder/cc-haha) 的专属 Linux 无头服务器优化版。**

原版致力于打造 macOS / Windows 的原生桌面端。而本分支的终极目标是：**将任意一台无屏幕的 Linux 服务器（如家里的 NAS、远端 VPS）改造为「云端 AI 编程工作站」**。

我们剥离了对桌面 GUI 的强依赖，深挖了其内置的 H5 远程访问功能。**你只需要一部手机或平板，通过浏览器即可随时随地远程控制 Linux 服务器，指挥 AI 写代码。**

---

## 🌟 核心亮点：手机掌控天下

- **纯后台 Headless 运行**：无需安装 X11 / Wayland，无需 `xvfb` 虚拟显示，直接作为底层系统级服务安静驻留。
- **开箱即用的 Linux 构建**：官方 Actions 已经打通，提供一键可安装的 `.deb` 包。
- **去签名校验打包**：去除了强行要求 Tauri 私钥的验证逻辑，支持在任意 GitHub 账号 Fork 后无缝自动编译发布。
- **H5 移动端工作台**：通过局域网 IP / Tailscale，打开手机浏览器即可查看 Diff、发送提示词、审批权限，真正的“随时随地开发”。

---

## 🚀 实战部署：三步打造云端工作站

如果你有一台 Debian / Ubuntu 服务器，请按以下步骤操作：

### 1. 下载与安装

前往 [Releases](https://github.com/1williamaoayers/cc-haha-linux/releases) 下载最新编译好的 `.deb` 包。

```bash
# 下载安装包
wget -qO cc-haha.deb "https://github.com/1williamaoayers/cc-haha-linux/releases/latest/download/Claude-Code-Haha_0.2.5_linux_x64_deb.deb"

# 安装
dpkg -i cc-haha.deb

# 自动补齐缺失的系统图形与网络库（必须执行）
apt-get update && apt-get install -f -y
```

### 2. 剥离启动 H5 核心服务

直接绕过桌面外壳，拉起底层 `claude-sidecar` 服务。

```bash
mkdir -p ~/.cc-haha

# 启动并置于后台
CLAUDE_H5_AUTO_PUBLIC_URL=1 \
CLAUDE_H5_DIST_DIR="/usr/lib/Claude Code Haha/_up_/dist" \
nohup /usr/bin/claude-sidecar server --host 0.0.0.0 --port 8080 --app-root ~/.cc-haha > /tmp/cc-haha-h5.log 2>&1 &
```
*服务将在 `8080` 端口监听所有网络请求。*

### 3. 强制获取 H5 专属私钥

由于是无头模式，我们需要通过内置 API 强制开启 H5 权限并生成 Token：

```bash
curl -s -X POST http://localhost:8080/api/h5-access/enable
```

返回的 JSON 数据中，你会得到一串 `h5_` 开头的 Token，**请复制并保存它**。

---

## 📱 手机端畅快开发

1. 确保你的手机与服务器在同一个网络（比如家庭局域网，或者使用 Tailscale 等组网工具）。
2. 在手机浏览器中访问服务器 IP，例如：`http://192.168.0.134:8080`
3. 在页面中粘贴你刚刚获取的 `h5_` 专属 Token。
4. 开始你优雅的云端 AI 编程体验！

---

## 🛠 二次开发与编译

本仓库已去除了对 `TAURI_SIGNING_PRIVATE_KEY` 的强校验。

你可以直接 Fork 本仓库，进入 **Actions**，点击 **Build Desktop (Dev)**，选择 `linux-x64` 或 `linux-arm64`，云端流水线将全自动为你编译出适用于你服务器架构的安装包。

---

## 📜 免责声明
本仓库基于 2026-03-31 从 Anthropic npm registry 泄露的 Claude Code 源码及 NanmiCoder 的衍生版本修复而来。仅供个人学习、研究与无头服务器的探索使用。原始版权归 Anthropic 所有。
