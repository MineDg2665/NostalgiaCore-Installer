#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear

echo -e "${YELLOW}=========================================="
echo
echo "          NostalgaiCore Installer"
echo
echo -e "=========================================${NC}"
echo

latest_release=$(curl -s https://api.github.com/repos/kotyaralih/NostalgiaCore/releases/latest | grep -o '"tag_name": "[^"]*' | sed 's/"tag_name": "//')

if [ -z "$latest_release" ]; then
    echo -e "${RED}Error: Could not retrieve the latest release. Exiting.${NC}"
    exit 1
fi

echo "Latest release: $latest_release"
echo

arch=$(uname -m)
if [ "$arch" == "x86_64" ]; then
    php_file="PHP-Linux_x86_64.tar.gz"
elif [ "$arch" == "aarch64" ]; then
    php_file="PHP_Linux_ARMv8.tar.gz"
else
    echo -e "${RED}Architecture $arch is not supported.${NC}"
    exit 1
fi

menu() {
    echo "Select installation option:"
    echo "1) Install PHP and Core"
    echo "2) Install PHP only"
    echo "3) Install Core only"
    echo
    read -p "Your choice: " choice
    case $choice in
        1) install_both ;;
        2) install_php ;;
        3) install_core ;;
        *) echo -e "${RED}Invalid choice, try again.${NC}"; menu ;;
    esac
}

install_php() {
    echo -e "${GREEN}[PHP] Downloading $php_file...${NC}"
    curl -L -o "$php_file" "https://github.com/kotyaralih/NostalgiaCore/releases/download/$latest_release/$php_file"
    echo -e "${GREEN}[PHP] Extracting...${NC}"
    tar -xzf "$php_file"
    echo -e "${GREEN}[PHP] Deleting archive...${NC}"
    rm "$php_file"
    echo -e "${GREEN}PHP installed!${NC}"
}

install_core() {
    core_file="NostalgiaCore-$latest_release.zip"
    extracted_dir="NostalgiaCore-$latest_release"
    echo -e "${GREEN}[CORE] Downloading $core_file...${NC}"
    curl -L -o "$core_file" "https://github.com/kotyaralih/NostalgiaCore/releases/download/$latest_release/$(basename "$core_file")"
    echo -e "${GREEN}[CORE] Extracting...${NC}"
    unzip -q "$core_file"
    if [ -d "$extracted_dir" ]; then
        cp -r "$extracted_dir"/* ./
        rm -rf "$extracted_dir"
    fi
    if [ -f "./start.sh" ]; then chmod 777 ./start.sh; fi
    echo -e "${GREEN}[CORE] Deleting archive...${NC}"
    rm "$core_file"
    echo -e "${GREEN}Core installed!${NC}"
}

install_both() {
    install_php
    install_core
    echo -e "${GREEN}Installation complete! To start the server, run ./start.bat.${NC}"
}

menu