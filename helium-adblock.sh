clear
if [[ -e /usr/local/sbin/helium ]]; then
     helium
else
     rm -rf /usr/local/sbin/helium && wget -q -O /usr/local/sbin/helium https://raw.githubusercontent.com/abidarwish/helium/main/helium.sh && chmod +x /usr/local/sbin/helium && helium
fi