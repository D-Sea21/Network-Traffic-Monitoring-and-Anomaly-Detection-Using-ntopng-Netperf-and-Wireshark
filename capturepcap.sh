#!/usr/bin/env bash
set -euo pipefail

# Tham số truyền vào: interface, label, duration, filter
IFACE="${1:-ens33}"
LABEL="${2:-normal}"     # normal | abnormal | custom
DURATION="${3:-60}"      # số giây bắt gói
FILTER="${4:-host 192.168.56.10 or host 192.168.56.11}"

# Tạo thư mục lưu pcap (dưới /tmp để tránh lỗi quyền)
PCAP_DIR="/tmp/pcaps"
mkdir -p "$PCAP_DIR"

# Lấy timestamp an toàn (ISO)
ts="$(date +%F_%H-%M-%S)"
FILE="${PCAP_DIR}/${LABEL}_${ts}.pcapng"

echo "[*] Bật promiscuous mode trên $IFACE"
sudo ip link set "$IFACE" promisc on

echo "[*] Bắt gói trong $DURATION giây -> $FILE"
sudo tshark -i "$IFACE" -f "$FILTER" -a "duration:$DURATION" -w "$FILE"

echo "[*] Tắt promiscuous mode"
sudo ip link set "$IFACE" promisc off

# Chuyển quyền file để user truy cập được
sudo chown "$(whoami)":"$(whoami)" "$FILE"

echo "[+] File đã lưu: $FILE"

