#!/bin/bash
#
# AGPL-3.0 License
#
# XRDP + Ubuntu Desktop autoinstallation script
#
# Usage ./autoinstall.sh <desktop-edition> <rdp-user> [password]
#
# Available desktop-edition options:
#     - kde : latest stable KDE Plasma Desktop
#     - gnome : latest stable GNOME Desktop
#     - xfce : latest stable Xfce Desktop
#
# If password is not provided root password will be used

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BG_RED='\033[41m'
NC='\033[0m'
HASH=$(openssl passwd -6 "$3")
DESKTOPS=("lxqt" "kde" "gnome" "xfce")

if [ "$EUID" -ne 0 ]
then echo -e "${WHITE}${BG_RED}Please run as root${NC}"
    exit
fi

if [[ -z "$1" || ! " ${DESKTOPS[@]} " =~ " $1 " ]];
then
    echo "Invalid or missing desktop environment. Available options: ${DESKTOPS[*]}"
    exit 1
fi

echo -e "${YELLOW}Upgrading system${NC}"
DEBIAN_FRONTEND=noninteractive apt update && apt upgrade -y
DEBIAN_FRONTEND=noninteractive apt install xrdp -y
adduser xrdp ssl-cert
ufw allow 3389/tcp
ufw reload

if [ "$1" == "lxqt" ]
then
    DEBIAN_FRONTEND=nonitercative apt install -y lxqt sddm
fi

if [ "$1" == "kde" ]
then
    DEBIAN_FRONTEND=noninteractive apt install kde-plasma-desktop -y
fi

if [ "$1" == "gnome" ]
then
    DEBIAN_FRONTEND=noninteractive apt install ubuntu-gnome-desktop -y
fi

if [ "$1" == "xfce" ]
then
    DEBIAN_FRONTEND=noninteractive apt install xfce4 xfce4-goodies -y
fi

useradd -m "$2" -s /bin/bash

if [ ! -z "$3" ]
then
    usermod -p "$HASH" "$2"
else
    ROOT_HASH=$(grep "^root:" /etc/shadow | cut -d: -f2)
    usermod -p "$ROOT_HASH" "$2"
fi

usermod -aG sudo $2

reboot
