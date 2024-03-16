#!/bin/bash
cek=$(cat /home/limit)
NIC=$(ip -o $ANU -4 route show to default | awk '{print $5}');
function start () {
clear
echo -e "Limit Speed All Service"
read -p "Set maximum download rate (in Kbps): " down
read -p "Set maximum upload rate (in Kbps): " up
if [[ -z "$down" ]] && [[ -z "$up" ]]; then
echo > /dev/null 2>&1
else
echo "Start Configuration"
sleep 0.5
wondershaper -a $NIC -d $down -u $up > /dev/null 2>&1
systemctl enable --now wondershaper.service
echo "start" > /home/limit
echo "Done"
sleep 1
clear
menu
fi
}
function stop () {
clear
wondershaper -ca $NIC
systemctl stop wondershaper.service
echo "Stop Configuration"
sleep 0.5
echo > /home/limit
echo "Done"
sleep 1
clear
menu
}
if [[ "$cek" = "start" ]]; then
sts="ON"
else
sts="OFF"
fi
clear
echo -e "——————————————————————————————————————"
echo -e "           BATASI KECEPATAN           "
echo -e "——————————————————————————————————————"
echo ""
echo -e "   Status : $sts"
echo -e "
 [\033[1;36m•1 \033[0m]  Start Limit
 [\033[1;36m•2 \033[0m]  Stop Limit
 [\033[1;36m•3 \033[0m]  Back To Main Menu"
echo ""
echo -e " \033[1;37mPress [ Ctrl+C ] • To-Exit-Script\033[0m"
echo ""
read -rp "Select menu : " -e num
if [[ "$num" = "1" ]]; then
start
elif [[ "$num" = "2" ]]; then
stop
elif [[ "$num" = "3" ]]; then
menu
else
clear
echo " Please Enter The Correct Number!"
sleep 0.5
limit
fi
