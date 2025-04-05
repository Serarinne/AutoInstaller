#!/bin/bash
clear
cp /etc/resolv.conf /etc/bu-resolv.conf
echo -e nameserver 2a01:4f8:c2c:123f::1 > /etc/resolv.conf
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

export serverURL="https://raw.githubusercontent.com/Serarinne/AutoInstaller/main"
export serverDate=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
export serverIP=$(wget -qO- icanhazip.com/ip)

echo -e "MEMULAI INSTALASI..."
apt install git curl -y >/dev/null 2>&1
sleep 1
if [ -f "/usr/local/etc/xray/domain" ]; then
    echo "Script sudah diinstall"
    exit 0
fi

mkdir /var/lib/premium-script;
sleep 2
clear
echo -e "INSTALASI DOMAIN..."
read -rp "Enter Your Domain : " serverDomain 
echo $serverDomain > /root/domain
echo "IP=$serverDomain" >> /var/lib/premium-script/ipvps.conf
echo "$serverIP" >> /root/serverip
echo "1.0" > /home/ver
echo -e "INSTALASI DOMAIN SELESAI"
sleep 2
clear
echo -e "INSTALASI SSH..."
export DEBIAN_FRONTEND=noninteractive
export NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

cd
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local.service

apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y
apt -y install wget curl
apt-get install netfilter-persistent

ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "menu" >> .profile

apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "${serverURL}/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "${serverURL}/vps.conf"
/etc/init.d/nginx restart

apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget ${serverURL}/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

apt -y install fail2ban

if [ -d '/usr/local/ddos' ]; then
	echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1

wget -q -O /etc/issue.net "${serverURL}/issues.net" && chmod +x /etc/issue.net
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config

iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

apt install resolvconf -y
systemctl start resolvconf.service
systemctl enable resolvconf.service
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
cd
chown -R www-data:www-data /home/vps/public_html
sleep 1
/etc/init.d/nginx restart >/dev/null 2>&1
sleep 1
/etc/init.d/cron restart >/dev/null 2>&1
sleep 1
/etc/init.d/fail2ban restart >/dev/null 2>&1
sleep 1
/etc/init.d/resolvconf restart >/dev/null 2>&1
sleep 1
/etc/init.d/vnstat restart >/dev/null 2>&1
history -c
echo "unset HISTFILE" >> /etc/profile
echo -e "INSTALASI SSH SELESAI"
sleep 2
clear
echo -e "INSTALASI XRAY-CORE..."
apt update -y
apt upgrade -y
apt install socat -y
apt install python -y
apt install curl -y
apt install wget -y
apt install sed -y
apt install nano -y
apt install python3 -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
chronyc sourcestats -v
chronyc tracking -v
date
apt install zip -y
apt install curl pwgen openssl netcat cron -y

mkdir -p /var/log/xray
chmod +x /var/log/xray
mkdir -p /usr/local/etc/xray

wget -O /usr/local/bin/xray "${serverURL}/xray.linux.64bit"
chmod +x /usr/local/bin/xray

mkdir /root/.acme.sh
curl ${serverURL}/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $serverDomain --standalone -k ec-256 --listen-v6 --insecure
~/.acme.sh/acme.sh --installcert -d $serverDomain --fullchainpath /usr/local/etc/xray/xray.crt --keypath /usr/local/etc/xray/xray.key --ecc
sleep 1
mkdir -p /home/vps/public_html

uuid=$(cat /proc/sys/kernel/random/uuid)
cat> /usr/local/etc/xray/config.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
    {
     "listen": "127.0.0.1",
     "port": "23456",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0,
            "level": 0,
            "email": ""
#VMESS
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
            "wsSettings": {
            "path": "/vmess",
            "headers": {
                "Host": ""
            }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
    "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true
    }
  }
}
END

rm -rf /etc/systemd/system/xray.service.d
rm -rf /etc/systemd/system/xray@.service.d

cat> /etc/systemd/system/xray.service << END
[Unit]
Description=XRAY-Websocket Service
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/config.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
END

cat> /etc/systemd/system/xray@.service << END
[Unit]
Description=XRAY-Websocket Service
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/%i.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
END

cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport;
             server_name 127.0.0.1 localhost;
             ssl_certificate /usr/local/etc/xray/xray.crt;
             ssl_certificate_key /usr/local/etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
             root /usr/share/nginx/html;
        }
EOF

sed -i '$ ilocation /' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iif ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ irewrite /(.*) /vless-ntls break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:14016;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /vmess-ntls' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:23456;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /vmess' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:23456;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sleep 1
systemctl daemon-reload
systemctl enable xray.service
systemctl start xray.service
systemctl restart xray.service
systemctl enable nginx
systemctl start nginx
systemctl restart nginx
echo -e "INSTALASI XRAY-CORE SELESAI"
sleep 2
clear
echo -e "INSTALASI RCLONE..."
sleep 1
apt install rclone
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "${serverURL}/rclone.conf"
git clone  https://github.com/MrMan21/wondershaper.git
cd wondershaper
make install
cd
rm -rf wondershaper
echo -e "INSTALASI RCLONE SELESAI"
sleep 2
clear
echo -e "INSTALASI LAINNYA..."
cd /usr/local/sbin
wget -O menu "${serverURL}/menu.sh" && chmod +x menu
wget -O tambah-host "${serverURL}/tambah-host.sh" && chmod +x tambah-host
wget -O restart-layanan "${serverURL}/restart-layanan.sh" && chmod +x restart-layanan
wget -O ubah-dns "${serverURL}/ubah-dns.sh" && chmod +x ubah-dns
wget -O helium-adblock "${serverURL}/helium-adblock.sh" && chmod +x helium-adblock
#wget -O bbrplus "${serverURL}/bbrplus.sh" && chmod +x bbrplus
wget -O speedtest "${serverURL}/speedtest.py" && chmod +x speedtest
wget -O hapus-otomatis "${serverURL}/hapus-otomatis.sh" && chmod +x hapus-otomatis
wget -O batasi-kecepatan "${serverURL}/batasi-kecepatan.sh" && chmod +x batasi-kecepatan
wget -O perbarui-sertifikat "${serverURL}/perbarui-sertifikat.sh" && chmod +x perbarui-sertifikat
echo "0 3 * * * root reboot" >> /etc/crontab
echo "0 2 * * * root /usr/local/sbin/hapus-otomatis" >> /etc/crontab
echo "0 2 * * * root /usr/bin/hapus-log" >> /etc/crontab
echo "0 5 * * * root cadangkan" >> /etc/crontab

cd /usr/bin
wget -O tambah-akun "${serverURL}/tambah-akun.sh" && chmod +x tambah-akun
wget -O cek-login "${serverURL}/cek-login.sh" && chmod +x cek-login
wget -O hapus-akun "${serverURL}/hapus-akun.sh" && chmod +x hapus-akun
wget -O perpanjang-akun "${serverURL}/perpanjang-akun.sh" && chmod +x perpanjang-akun
wget -O cek-akun "${serverURL}/cek-akun.sh" && chmod +x cek-akun
wget -O cek-bandwidth-pengguna "${serverURL}/cek-bandwidth-pengguna.sh" && chmod +x cek-bandwidth-pengguna
wget -O cek-bandwidth "${serverURL}/cek-bandwidth.sh" && chmod +x cek-bandwidth
wget -O cadangkan "${serverURL}/cadangkan.sh" && chmod +x /usr/bin/cadangkan
wget -O pulihkan "${serverURL}/pulihkan.sh" && chmod +x /usr/bin/pulihkan
wget -O hapus-log "${serverURL}/hapus-log.sh" && chmod +x /usr/bin/hapus-log
cd
if [ ! -f "/etc/cron.d/hapus-log" ]; then
cat> /etc/cron.d/hapus-log << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/2 * * * * root /usr/bin/hapus-log
END
fi
service cron restart > /dev/null 2>&1
cp /etc/bu-resolv.conf /etc/resolv.conf
rm install_ipv6_test.sh
reboot
