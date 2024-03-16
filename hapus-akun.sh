#!/bin/bash
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/usr/local/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "Tidak ada akun"
        echo ""
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
exp=$(grep -E "^### " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/config.json
rm -f /usr/local/etc/xray/$user.json
rm -f /home/vps/public_html/$user-VMESS.yaml
systemctl restart xray.service
clear
echo -e ""
echo " Client Name : $user"
echo " Expired On  : $exp"
echo -e "Akun dihapus"
echo ""
read -p "$( echo -e "Kembali") "
menu
