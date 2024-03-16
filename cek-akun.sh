#!/bin/bash
clear
serverDomain=$(cat /root/domain)
serverIP=$(cat /root/serverip)
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/usr/local/etc/xray/config.json")
        if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
                echo ""
                echo "Tidak ada akun"
                clear
                exit 1
        fi

	echo -e "——————————————————————————————————————"
	echo -e "              HAPUS AKUN              "
	echo -e "——————————————————————————————————————"
        echo "     No  Expired   User"
        grep -E "^### " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2-3 | nl -s ') '
        until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
                if [[ ${CLIENT_NUMBER} == '1' ]]; then
                        read -rp "Masukkan nomor akun [1]: " CLIENT_NUMBER
                else
                        read -rp "Masukkan nomor akun [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
                fi
        done
user=$(grep -E "^### " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep "},{" /usr/local/etc/xray/config.json | cut -b 11-46 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmesslink2="vmess://$(base64 -w 0 /usr/local/etc/xray/$user.json)"
clear
echo -e ""
echo -e "═══[XRAY VMESS WS]════"
echo -e "Remarks           : ${user}"
echo -e "Domain            : ${serverDomain}"
echo -e "IP/Host           : ${serverIP}"
echo -e "Port TLS          : 443"
echo -e "Port None TLS     : 80, 8080, 8880"
echo -e "ID                : ${uuid}"
echo -e "AlterId           : 0"
echo -e "Security          : Auto"
echo -e "Network           : WS"
echo -e "Path              : /vmess-ntls /vmess"
echo -e "═══════════════════"
echo -e "Link WS None TLS  : ${vmesslink2}"
echo -e "═══════════════════"
echo -e "YAML WS None TLS  : http://${serverIP}:81/$user-VMESS.yaml"
echo -e "═══════════════════"
echo -e "Expired On        : $exp"
echo -e "═══════════════════"
echo -e ""
echo ""
read -p "$( echo -e "Kembali") "
menu
