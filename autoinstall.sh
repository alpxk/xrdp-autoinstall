#!/bin/bash
#
# AGPL-3.0 License
#
# XRDP + Ubuntu Desktop autoinstallation script
#
# Usage autoinstall.sh <desktop-edition> <rdp-user> [password]
# Available desktop-edition options:
# - kde : latest stable KDE Plasma Desktop
# - gnome :
# - xfce : 

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BG_RED='\033[41m'
NC='\033[0m'

if [ ! -t 0 ]
then echo -e "${WHITE}${BG_RED}Please run this script directly${NC}"
    exit
fi
