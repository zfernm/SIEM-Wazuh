#!/bin/bash
# ===========================================
# Script Instalasi Wazuh Agent (Debian/Ubuntu)
# ===========================================

# Konfigurasi
WAZUH_VERSION="4.14.0-1"
WAZUH_MANAGER="192.168.103.201"
WAZUH_AGENT_NAME="LinuxAgent1"
AGENT_PACKAGE="wazuh-agent_${WAZUH_VERSION}_amd64.deb"
DOWNLOAD_URL="https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/${AGENT_PACKAGE}"

echo "----------------------------------------"
echo "🚀 Memulai instalasi Wazuh Agent versi ${WAZUH_VERSION}"
echo "----------------------------------------"

# Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "⚠️  Jalankan script ini sebagai root (sudo bash install_wazuh_agent.sh)"
  exit 1
fi

# Update package list
echo "[1/5] Update repository..."
apt-get update -y

# Download paket Wazuh Agent
echo "[2/5] Mengunduh paket Wazuh Agent..."
wget -q "$DOWNLOAD_URL" -O "$AGENT_PACKAGE"
if [ $? -ne 0 ]; then
  echo "❌ Gagal mengunduh paket dari $DOWNLOAD_URL"
  exit 1
fi

# Instalasi paket Wazuh Agent
echo "[3/5] Menginstal Wazuh Agent..."
WAZUH_MANAGER="$WAZUH_MANAGER" WAZUH_AGENT_NAME="$WAZUH_AGENT_NAME" dpkg -i "$AGENT_PACKAGE"

# Reload systemd dan aktifkan service
echo "[4/5] Mengaktifkan service wazuh-agent..."
systemctl daemon-reload
systemctl enable wazuh-agent

# Jalankan service
echo "[5/5] Menjalankan service wazuh-agent..."
systemctl start wazuh-agent

# Verifikasi status
echo "----------------------------------------"
systemctl status wazuh-agent --no-pager
echo "----------------------------------------"
echo "✅ Instalasi Wazuh Agent selesai!"
echo "Agent name  : $WAZUH_AGENT_NAME"
echo "Manager IP  : $WAZUH_MANAGER"
echo "----------------------------------------"
