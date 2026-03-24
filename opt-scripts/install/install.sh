#!/bin/bash

# install.sh - Interactive wrapper for trzsz installation
# Detects system type and calls appropriate installation method

echo "=== trzsz Installation Script ==="
echo ""
echo "Please select your system type:"
echo "1) Ubuntu"
echo "2) Debian"
echo ""

while true; do
    read -p "Enter your choice [1-2]: " choice

    case $choice in
        1)
            echo "Ubuntu selected. Starting installation..."
            break
            ;;
        2)
            echo "Debian selected. Starting installation..."
            break
            ;;
        *)
            echo "Error: Invalid choice. Please enter 1 for Ubuntu or 2 for Debian."
            ;;
    esac
done

echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Call trzsz.sh with the selected option
if [ -f "$SCRIPT_DIR/trzsz.sh" ]; then
    chmod +x "$SCRIPT_DIR/trzsz.sh"
    "$SCRIPT_DIR/trzsz.sh" "$choice"
else
    echo "Error: trzsz.sh not found in the same directory!"
    echo "Please ensure both install.sh and trzsz.sh are in the same folder."
    exit 1
fi

echo ""
echo "Installation process completed."