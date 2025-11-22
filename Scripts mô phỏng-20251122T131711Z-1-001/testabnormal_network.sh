#!/usr/bin/env bash
set -euo pipefail

SERVER_IP="${1:-192.168.12.3}"
ts="$(date +%F_%H-%M-%S)"
OUT="logs/anomaly_$ts"
mkdir -p "$OUT"

echo "[*] SYN burst (giới hạn tốc độ, 500 gói)"
sudo hping3 -S "$SERVER_IP" -p 80 -i u10 -c 100000 2>&1 | tee "$OUT/syn_burst.txt"

sleep 2
echo "[*] UDP burst (500 gói)"
sudo hping3 --udp "$SERVER_IP" -p 5001 -i u1000 -c 1500 2>&1 | tee "$OUT/udp_burst.txt"

sleep 2
echo "[*] Port sweep chậm (1–1024, 1024 gói)"
sudo hping3 -S "$SERVER_IP" -p ++1 -c 1024 -i u30000 2>&1 | tee "$OUT/port_sweep.txt"

echo "Done. Logs in $OUT"
