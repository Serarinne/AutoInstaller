#!/bin/bash
clear
load_cpu=$(printf '%-3s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
uptime="$(uptime -p | cut -d " " -f 2-10)"
tram=$(free -m | awk 'NR==2 {print $2}')
uram=$(free -m | awk 'NR==2 {print $3}')
#LAYANAN
nginxS="$(systemctl show nginx.service --no-page)"
nginxStatus=$(echo "${nginxS}" | grep 'ActiveState=' | cut -f2 -d=)
xrayS="$(systemctl show xray.service --no-page)"
xrayStatus=$(echo "${xrayS}" | grep 'ActiveState=' | cut -f2 -d=)
# TOTAL ACC XRAYS WS & XTLS
vmess=$(grep -c -E "^### $user" "/usr/local/etc/xray/config.json")
# Total BANDWIDTH
bandwith_hari_ini=$(vnstat -d --oneline | awk -F\; '{print $6}' | sed 's/ //')
bandwith_bulan_ini=$(vnstat -m --oneline | awk -F\; '{print $11}' | sed 's/ //')
clear
echo ""
echo -e "————————————————————————————————————————————————————————"
echo -e "                         SERVER3                        "
echo -e "————————————————————————————————————————————————————————"
echo -e "  UPTIME  :  $uptime  "
echo -e "  CPULOAD :  $load_cpu  "
echo -e "  RAM     :  $uram MB / $tram MB  "
echo -e "  DOMAIN  :  $(cat /root/domain)  "
echo -e "  IP      :  $(cat /root/serverip)  "
echo -e "  Nginx   :  ${nginxStatus}"
echo -e "  XRAY    :  ${xrayStatus}"
echo -e "————————————————————————————————————————————————————————"
echo -e "                   TOTAL AKUN : ${vmess}          "
echo -e "————————————————————————————————————————————————————————"
echo -e "  1   BUAT AKUN            4   CEK LOGIN"
echo -e "  2   HAPUS AKUN           5   CEK CONFIG"
echo -e "  3   PERPANJANG AKUN      6   CEK BANDWIDTH PENGGUNA"
echo -e "————————————————————————————————————————————————————————"
echo -e "  7   UBAH DOMAIN          11  SPEEDTEST"
echo -e "  8   PERBARUI SERTIFIKAT  12  BATASI KECEPATAN"
echo -e "  9   UBAH DNS             13  CEK BANDWIDTH SISTEM"
echo -e "  10  ADBLOCK              14  RESTART SISTEM"
echo -e ""
echo -e "  15  CADANGKAN            17  XRAY-CORE MENU"
echo -e "  16  PULIHKAN             18  REBOOT"
echo -e "————————————————————————————————————————————————————————"
echo -e "  HARI INI    : $bandwith_hari_ini "
echo -e "  BULAN INI   : $bandwith_bulan_ini "
echo -e "————————————————————————————————————————————————————————"
echo ""
read -p "Masukkan pilihan [1-17] : " menu
case $menu in
1)
tambah-akun
;;
2)
hapus-akun
;;
3)
perpanjang-akun
;;
4)
cek-login
;;
5)
cek-akun
;;
6)
cek-bandwidth-pengguna
;;
7)
tambah-host
;;
8)
perbarui-sertifikat
;;
9)
ubah-dns
;;
10)
helium-adblock
;;
11)
speedtest
;;
12)
batasi-kecepatan
;;
13)
cek-bandwidth
;;
14)
restart-layanan
;;
15)
cadangkan
;;
16)
pulihkan
;;
17)
clear;
wget -q -O /usr/bin/xraychanger "https://raw.githubusercontent.com/NevermoreSSH/Xcore-custompath/main/xraychanger.sh" && chmod +x /usr/bin/xraychanger && xraychanger
;;
18)
reboot
;;
*)
clear
menu
;;
esac
