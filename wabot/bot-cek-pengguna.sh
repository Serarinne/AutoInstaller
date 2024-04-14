#!/bin/bash
clear
Total_Akun=$(grep -c -E "^### " "/usr/local/etc/xray/config.json")
echo "Total Akun: ${Total_Akun}"
echo grep -E "^### " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2-3 | nl -s ') '
