#!/usr/bin/env bash
set -euo pipefail

SERVER_IP="${1:-192.168.12.3}"
DURATION="${2:-30}"
UDP_PAYLOAD="${3:-1472}"

ts="$(date +%F_%H-%M-%S)"
OUT="logs/normal_$ts"
mkdir -p "$OUT"

echo "[*] Ping"
ping -i 0.2 -c 100 "$SERVER_IP" | tee "$OUT/ping.txt"

echo "[*] TCP_STREAM"
netperf -H "$SERVER_IP" -t TCP_STREAM -l "$DURATION" | tee "$OUT/tcp_stream.txt"

echo "[*] UDP_STREAM"
netperf -H "$SERVER_IP" -t UDP_STREAM -l "$DURATION" -- -m "$UDP_PAYLOAD" | tee "$OUT/udp_stream.txt"

echo "[*] TCP_RR"
netperf -H "$SERVER_IP" -t TCP_RR -l "$DURATION" | tee "$OUT/tcp_rr.txt"

echo "Done. Logs in $OUT"
