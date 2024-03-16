<!DOCTYPE html>
♦️ Debian 10 / 11<br>
 
  ```html
 apt update -y && apt upgrade -y && apt dist-upgrade -y && reboot
  ```
  ♦️ Ubuntu 18.04<br>
  
  ```html
 apt-get update && apt-get upgrade -y && apt dist-upgrade -y && update-grub && reboot
 ```
♦️ Installation ( Xray-core Custom ) Link<br>

  ```html
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl && wget https://raw.githubusercontent.com/Serarinne/AutoInstaller/main/install.sh && chmod +x install.sh && ./install.sh
  ```
</html>