#!/bin/bash
# 这是一个辅助脚本，用于在 Debian/Ubuntu 服务器上一键安装并启动 cc-haha systemd 守护进程

set -e

if [ "$EUID" -ne 0 ]; then
  echo "请使用 root 权限执行此脚本 (sudo ./install-service.sh)"
  exit 1
fi

echo "==> 正在复制 systemd 服务文件..."
cp claude-h5.service /etc/systemd/system/

echo "==> 重新加载 systemd 配置..."
systemctl daemon-reload

echo "==> 启动并设置开机自启..."
systemctl enable --now claude-h5.service

echo "==> 服务启动状态："
systemctl status claude-h5.service --no-pager

echo ""
echo "=================================================="
echo "服务已成功作为守护进程启动！"
echo "请执行以下命令来激活 H5 并获取访问 Token："
echo "curl -s -X POST http://localhost:8080/api/h5-access/enable"
echo "=================================================="
