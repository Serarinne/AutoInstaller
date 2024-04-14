#!/bin/bash
clear
Total_Akun=$(grep -c -E "^### " "/usr/local/etc/xray/config.json")
echo -e "Total Akun: ${Total_Akun}"
grep -E "^### " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2-3 | nl -s ') '
