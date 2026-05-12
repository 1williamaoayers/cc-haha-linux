# Claude Code Haha (Linux Headless & H5 Edition)

<p align="center">
  <img src="docs/images/app-icon.png" alt="Claude Code Haha" width="240">
</p>

<div align="center">

[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/1williamaoayers/cc-haha-linux/release-desktop.yml?style=social)](https://github.com/1williamaoayers/cc-haha-linux/actions)
[![License](https://img.shields.io/github/license/NanmiCoder/cc-haha)](https://github.com/1williamaoayers/cc-haha-linux/blob/main/LICENSE)
[![中文](https://img.shields.io/badge/🇨🇳_中文-Available-green)](README.md)
[![English](https://img.shields.io/badge/🇺🇸_English-Current-blue)](README.en.md)

</div>

**This project is a specialized Linux Headless fork of [NanmiCoder/cc-haha](https://github.com/NanmiCoder/cc-haha).**

While the original project focuses on building a native desktop app for macOS and Windows, the ultimate goal of this branch is to **transform any headless Linux server (e.g., your home NAS or a remote VPS) into a "Cloud AI Programming Workstation".**

We have decoupled the strong dependency on the desktop GUI and heavily utilized its built-in H5 remote access capability. **You only need a phone or tablet to remotely control your Linux server via a browser and direct the AI to write code for you, anytime, anywhere.**

---

## 🌟 Core Highlights

- **Pure Headless Backend**: No need to install X11 / Wayland, no need for `xvfb` virtual displays. It resides quietly as an underlying system service.
- **Out-of-the-box Linux Builds**: Official GitHub Actions workflows are fully operational, providing easy-to-install `.deb` packages.
- **Signature-Free Packaging**: The forced Tauri private key validation has been removed, allowing seamless auto-compilation and releases upon forking to any GitHub account.
- **H5 Mobile Workspace**: Via LAN IP or Tailscale, simply open your mobile browser to view diffs, send prompts, and approve permissions—true "develop on the go".

---

## 🚀 Practical Deployment: 3 Steps to a Cloud Workstation

If you have a Debian / Ubuntu server, please follow these steps:

### 1. Download and Install

Go to [Releases](https://github.com/1williamaoayers/cc-haha-linux/releases) to download the latest compiled `.deb` package.

```bash
# Download the package
wget -qO cc-haha.deb "https://github.com/1williamaoayers/cc-haha-linux/releases/latest/download/Claude-Code-Haha_0.2.5_linux_x64_deb.deb"

# Install
dpkg -i cc-haha.deb

# Automatically fix missing system graphics and networking libraries (mandatory)
apt-get update && apt-get install -f -y
```

### 2. Isolate and Start the Core H5 Service

Bypass the desktop shell completely and spin up the underlying `claude-sidecar` service.

```bash
mkdir -p ~/.cc-haha

# Start in the background
CLAUDE_H5_AUTO_PUBLIC_URL=1 \
CLAUDE_H5_DIST_DIR="/usr/lib/Claude Code Haha/_up_/dist" \
nohup /usr/bin/claude-sidecar server --host 0.0.0.0 --port 8080 --app-root ~/.cc-haha > /tmp/cc-haha-h5.log 2>&1 &
```
*The service will now quietly listen to all network requests on port `8080`.*

### 3. Force Retrieve the Exclusive H5 Private Key

Because we are in headless mode, we need to force-enable H5 permissions and generate a Token via the built-in API:

```bash
curl -s -X POST http://localhost:8080/api/h5-access/enable
```

In the returned JSON data, you will receive a Token starting with `h5_`. **Please copy and save it.**

---

## 📱 Seamless Mobile Development

1. Ensure your phone is on the same network as the server (e.g., home Wi-Fi, or using a VPN like Tailscale).
2. Open your mobile browser and access the server's IP, for example: `http://192.168.0.134:8080`
3. Paste the exclusive `h5_` Token you just obtained.
4. Start your elegant cloud-based AI programming experience!

---

## 🛠 Secondary Development & Compilation

This repository has removed the strict validation for `TAURI_SIGNING_PRIVATE_KEY`.

You can fork this repository, go to **Actions**, click **Build Desktop (Dev)**, select `linux-x64` or `linux-arm64`, and the cloud pipeline will automatically compile an installation package suitable for your server's architecture.

---

## 📜 Disclaimer
This repository is based on the Claude Code source code leaked from the Anthropic npm registry on 2026-03-31, and its derivative version by NanmiCoder. It is strictly for personal learning, research, and exploration on headless servers. The original copyright belongs to Anthropic.
