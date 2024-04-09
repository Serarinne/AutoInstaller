#!/bin/bash
clear
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

export serverURL="https://raw.githubusercontent.com/Serarinne/AutoInstaller/main/wabot"

mkdir /root/wabot
cd /root/wabot
wget ${serverURL}/index.py && chmod +x index.py
wget ${serverURL}/requirements.txt && chmod +x requirements.txt

cd /usr/bin
wget -O bot-tambah-akun "${serverURL}/bot-tambah-akun.sh" && chmod +x bot-tambah-akun
