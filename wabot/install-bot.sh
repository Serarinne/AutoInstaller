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
wget ${serverURL}/.env && chmod +x .env

cd /usr/bin
wget -O bot-tambah-akun "${serverURL}/bot-tambah-akun.sh" && chmod +x bot-tambah-akun
wget -O bot-cek-pengguna "${serverURL}/bot-cek-pengguna.sh" && chmod +x bot-cek-pengguna

apt install python3-pip
pip install Flask
pip install requests
pip install jsonify
pip install requests-toolbelt
pip install python-dotenv
pip install spur

cat > /etc/systemd/system/wabot.service <<-END
[Unit]
Description=Run bot WA

[Service]
ExecStart=nohup python3 /root/wabot/index.py &
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
END

chmod +x /etc/systemd/system/wabot.service
cd /etc/systemd/system
systemctl enable wabot.service
systemctl start wabot.service
systemctl restart wabot.service
