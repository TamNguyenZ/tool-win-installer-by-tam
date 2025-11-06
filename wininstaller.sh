#!/bin/bash
set -e

# Detect distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "⚠️ Không xác định được distro, mặc định dùng Debian method."
    DISTRO="debian"
fi

echo "🌐 Detected distro: $DISTRO"

if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "linuxmint" ]]; then
    echo "➡️ Sử dụng PPA deadsnakes cho Ubuntu..."
    sudo apt update -y
    sudo apt install -y software-properties-common
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update -y
    sudo apt install -y python3.10 python3.10-venv python3.10-distutils python3.10-dev
elif [[ "$DISTRO" == "debian" || "$DISTRO" == "pop" || "$DISTRO" == "kali" ]]; then
    echo "➡️ Sử dụng pyenv cho Debian..."
    sudo apt update -y
    sudo apt install -y git build-essential libssl-dev zlib1g-dev libncurses5-dev \
        libffi-dev libsqlite3-dev libreadline-dev libbz2-dev liblzma-dev tk-dev libgdbm-dev curl
    curl https://pyenv.run | bash
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    pyenv install 3.10.13
    pyenv global 3.10.13
else
    echo "⚠️ Distro không xác định, fallback sang pyenv method."
    sudo apt update -y
    sudo apt install -y git build-essential libssl-dev zlib1g-dev libncurses5-dev \
        libffi-dev libsqlite3-dev libreadline-dev libbz2-dev liblzma-dev tk-dev libgdbm-dev curl
    curl https://pyenv.run | bash
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    pyenv install 3.10.13
    pyenv global 3.10.13
fi

echo "✅ Python 3.10 installed:"
python3 --version

# === Chạy script win.py nếu tồn tại ===
if [ -f "win.py" ]; then
    echo "🚀 Chạy file win.py bằng Python 3..."
    python3 win.py
else
    echo "⚠️ Không tìm thấy file win.py trong thư mục hiện tại!"
fi
