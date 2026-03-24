#!/bin/bash

# trzsz.sh - Install trzsz based on system type
# Usage: ./trzsz.sh [1|2]
# 1 = Ubuntu
# 2 = Debian

if [ $# -ne 1 ]; then
    echo "Usage: $0 [1|2]"
    echo "  1 = Ubuntu"
    echo "  2 = Debian"
    exit 1
fi

case $1 in
    1)
        echo "Installing trzsz for Ubuntu..."
        sudo apt update && sudo apt install software-properties-common
        sudo add-apt-repository ppa:trzsz/ppa && sudo apt update
        sudo apt install trzsz
        ;;
    2)
        echo "Installing trzsz for Debian..."
        sudo apt install curl gpg
        curl -s 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x7074ce75da7cc691c1ae1a7c7e51d1ad956055ca' \
            | gpg --dearmor -o /usr/share/keyrings/trzsz.gpg
        echo 'deb [signed-by=/usr/share/keyrings/trzsz.gpg] https://ppa.launchpadcontent.net/trzsz/ppa/ubuntu jammy main' \
            | sudo tee /etc/apt/sources.list.d/trzsz.list
        sudo apt update
        sudo apt install trzsz
        ;;
    *)
        echo "Error: Invalid option"
        echo "Please use:"
        echo "  1 for Ubuntu"
        echo "  2 for Debian"
        exit 1
        ;;
esac

echo "trzsz installation completed!"