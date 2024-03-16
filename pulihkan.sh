#!/bin/bash
clear
echo ""
#read -rp " Password File: " -e InputPass
read -rp " Link File: " -e url
wget -O backup.zip "$url"
#unzip -P $InputPass /root/backup.zip &> /dev/null
unzip backup.zip
rm -f backup.zip
sleep 1
echo -e "Memulihkan"
#cp -r /root/backup/.acme.sh /root/ &> /dev/null
#cp -r /root/backup/premium-script /var/lib/ &> /dev/null
#cp -r /root/backup/xray /usr/local/etc/ &> /dev/null
cp -r /root/backup/*.json /usr/local/etc/xray/ >/dev/null
cp -r /root/backup/public_html /home/vps/ &> /dev/null
cp -r /root/backup/crontab /etc/ &> /dev/null
cp -r /root/backup/cron.d /etc/ &> /dev/null
rm -rf /root/backup
rm -f backup.zip
echo ""
echo -e "Data dipulihkan"
echo ""
echo -e "Memulai ulang sistem"
systemctl restart nginx
systemctl restart xray.service
service cron restart
echo ""
read -p "$( echo -e "Kembali") "
menu
