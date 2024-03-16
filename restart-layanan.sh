#!/bin/bash
clear
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "RESTARTING..."
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e " "
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "RESTARTING..."
    done
    echo -e " [OK]"
    tput cnorm
}
res1() {
    systemctl fail2ban.service
}
res2() {
    systemctl restart cron.service
}
res3() {
    systemctl restart nginx.service
}
res4() {
    systemctl restart xray.service
}

clear
echo -e ""
echo -e "Restart Fail2ban"
fun_bar 'res1'
echo -e "Restart Cron"
fun_bar 'res2'
echo -e "Restart Nginx"
fun_bar 'res3'
echo -e "Restart Vmess"
fun_bar 'res4'
echo -e ""
read -p "$( echo -e "Kembali") "
menu
