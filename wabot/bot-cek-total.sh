#!/bin/bash
Total_Akun=$(grep -c -E "^### " "/usr/local/etc/xray/config.json")
echo -e "${Total_Akun}"
