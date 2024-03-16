clear
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "             CEK BANDWIDTH            "
echo -e "——————————————————————————————————————"
echo -e ""
echo -e " 1 ⸩ View Total Bandwidth Remaining"
echo -e " 2 ⸩ Usage Table Every 5 Minutes"
echo -e " 3 ⸩ Hourly Usage Table"
echo -e " 4 ⸩ Daily Usage Table"
echo -e " 5 ⸩ Monthly Usage Table"
echo -e " 6 ⸩ Annual Usage Table"
echo -e " 7 ⸩ Highest Usage Table"
echo -e " 8 ⸩ Hourly Usage Statistics"
echo -e " 9 ⸩ View Current Active Usage"
echo -e " 10 ⸩ View Current Active Usage Traffic [5s]"

echo -e "     x ⸩   Menu"
echo -e ""
echo -e "——————————————————————————————————————"
echo -e ""
read -p "     [#]  Masukkan Nomor :  " noo
echo -e ""

case $noo in
1)
echo -e "——————————————————————————————————————"
echo -e "    TOTAL SERVER BANDWITH REMAINING"
echo -e "——————————————————————————————————————"
echo -e ""

vnstat

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "$baris2"
;;

2)
echo -e "——————————————————————————————————————"
echo -e "  BANDWITH USAGE EVERY 5 MINUTES"
echo -e "——————————————————————————————————————"
echo -e ""

vnstat -5

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "$baris2"
;;

3)
echo -e "——————————————————————————————————————"
echo -e "    HOURLY BANDWITH USAGE"
echo -e "——————————————————————————————————————"
echo -e ""

vnstat -h

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "$baris2"
;;

4)
echo -e "——————————————————————————————————————"
echo -e "   DAILY BANDWITH USAGE"
echo -e "——————————————————————————————————————"
echo -e ""

vnstat -d

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "$baris2"
;;

5)
echo -e "——————————————————————————————————————"
echo -e "   BANDWITH USAGE EVERY MONTH"
echo -e "——————————————————————————————————————"
echo -e ""

vnstat -m

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "$baris2"
;;

6)
echo -e "——————————————————————————————————————"
echo -e "   BANDWITH USAGE EVERY YEAR"
echo -e "——————————————————————————————————————"
echo -e ""

vnstat -y

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "$baris2"
;;

7)
echo -e "——————————————————————————————————————"
echo -e "    HIGHEST BANDWITH USAGE"
echo -e "——————————————————————————————————————"
echo -e ""

vnstat -t

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "$baris2"
;;

8)
echo -e "——————————————————————————————————————"
echo -e " HOURLY USED BANDWITH GRAPH"
echo -e "——————————————————————————————————————"
echo -e ""

vnstat -hg

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "$baris2"
;;

9)
echo -e "——————————————————————————————————————"
echo -e "  LIVE CURRENT BANDWITH USAGE"
echo -e "——————————————————————————————————————"
echo -e " CTRL+C Untuk Berhenti!"
echo -e ""

vnstat -l

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "$baris2"
;;

10)
echo -e "——————————————————————————————————————"
echo -e "   LIVE TRAFFIC USING BANDWITH "
echo -e "——————————————————————————————————————"
echo -e ""

vnstat -tr

echo -e ""
echo -e "——————————————————————————————————————"
echo -e "$baris2"
;;

x)
sleep 1
menu
;;

*)
sleep 1
echo -e "Nomor Yang Anda Masukkan Salah!"
;;
esac
read -n 1 -s -r -p "Kembali"

menu
