#!/bin/bash
#
# AGPL-3.0 License
#
# XRDP + Ubuntu Desktop autoinstallation script
#
# Usage autoinstall.sh <desktop-edition> <rdp-user> [password]
#
# Available desktop-edition options:
# - kde : latest stable KDE Plasma Desktop
# - gnome : latest stable GNOME Desktop
# - xfce : latest stable Xfce Desktop
#
#

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BG_RED='\033[41m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]
then echo -e "${WHITE}${BG_RED}Please run as root${NC}"
    exit
fi

if [ "$1" == "kde" ]
then
    apt update & apt upgrade -y
    apt install kde-plasma-desktop -y
    apt install xrdp -y
    adduser xrdp ssl-cert
    ufw allow 3389/tcp
    ufw reload
fi

if [ "$1" == "gnome" ]
then
    apt update & apt upgrade -y
    apt install ubuntu-gnome-desktop -y
    apt install xrdp -y
    adduser xrdp ssl-cert
    ufw allow 3389/tcp
    ufw reload
fi

if [ "$1" == "xfce" ]
then
    apt update & apt upgrade -y
    apt install xfce4 xfce4-goodies -y
    apt install xrdp -y
    adduser xrdp ssl-cert
    ufw allow 3389/tcp
    ufw reload
fi

useradd -m "$2" --shell /bin/bash

if [ ! -z "$3" ]
then
    usermod -p "$3" "$2"
else
    ROOT_HASH=$(grep "^root:" /etc/shadow | cut -d: -f2)
    usermod -p "$ROOT_HASH" "$2"
fi

usermod -aG sudo $2

reboot
