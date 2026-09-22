#!/data/data/com.termux/files/usr/bin/bash
set -e

BOT_URL="https://raw.githubusercontent.com/cryptoai02011990-afk/Tradebot-site/main/tradebot.pyz"
BOT_FILE="$HOME/tradebot.pyz"

echo ""
echo "================================================"
echo "        TradeBot Installer v1.0"
echo "================================================"
echo ""

if [ ! -d "/data/data/com.termux" ]; then
    echo "ERROR: Must run inside Termux."
    echo "Get it from F-Droid: https://f-droid.org"
    exit 1
fi

echo "[1/7] Checking internet..."
if ! ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo "ERROR: No internet. Connect and retry."
    exit 1
fi
echo "       OK"

echo "[2/7] Updating Termux packages (2-3 min)..."
pkg update -y > /dev/null 2>&1
pkg upgrade -y > /dev/null 2>&1
echo "       Done"

echo "[3/7] Installing Python + dependencies..."
pkg install python python-cryptography termux-api nano tar -y > /dev/null 2>&1
echo "       Done"

echo "[4/7] Installing CCXT..."
pip install ccxt --no-deps --break-system-packages > /dev/null 2>&1
pip install requests --break-system-packages > /dev/null 2>&1
echo "       Done"

echo "[5/7] Requesting storage access (tap ALLOW)..."
termux-setup-storage
sleep 5

echo "[6/7] Downloading TradeBot..."
curl -sL "$BOT_URL" -o "$BOT_FILE"
chmod +x "$BOT_FILE"

if [ ! -f "$BOT_FILE" ]; then
    echo "ERROR: Download failed."
    exit 1
fi
echo "       Downloaded to $BOT_FILE"

echo "[7/7] License activation"
echo ""
echo "------------------------------------------------"
echo "  Paste your license key and press Enter."
echo "------------------------------------------------"
read -p "License key: " LIC_KEY

if [ -z "$LIC_KEY" ]; then
    echo "ERROR: No key entered. Rerun the installer."
    exit 1
fi

python "$BOT_FILE" activate "$LIC_KEY"

termux-wake-lock 2>/dev/null

echo ""
echo "================================================"
echo "        Installation Complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo ""
echo "  1. Setup: python ~/tradebot.pyz setup"
echo "  2. Start: python ~/tradebot.pyz start"
echo "  3. Stop:  Volume Down + C"
echo ""
echo "Support: crypto.ai02011990@gmail.com"
echo ""
