#!/bin/bash
clear
export serverURL="https://raw.githubusercontent.com/Serarinne/AutoInstaller/main"
read -rp "Enter Your Domain : " serverDomain
rm -f /var/lib/premium-script/ipvps.conf
rm -f /root/domain
echo $serverDomain > /root/domain
echo "IP=$serverDomain" >> /var/lib/premium-script/ipvps.conf
clear
sleep 1
source /var/lib/premium-script/ipvps.conf
systemctl stop nginx
systemctl stop xray.service
rm -r /root/.acme.sh
sleep 1
mkdir /root/.acme.sh
curl ${serverURL}/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $serverDomain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $serverDomain --fullchainpath /usr/local/etc/xray/xray.crt --keypath /usr/local/etc/xray/xray.key --ecc
sleep 1
systemctl restart nginx
systemctl restart xray.service
clear
menu