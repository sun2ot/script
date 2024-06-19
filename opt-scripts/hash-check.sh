#!/bin/bash

# Check if all required parameters are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: hash-check <file_path> <hash_algorithm> <hash_value>"
    exit 1
fi

file_path=$1
hash_algorithm=$2
hash_value=$3

# Check if file exists
if [ ! -f "$file_path" ]; then
    echo "Error: File not found."
    exit 1
fi

# Calculate hash value of the file
case $hash_algorithm in
    md5)
        calculated_hash=$(md5sum "$file_path" | awk '{print $1}')
        ;;
    sha1)
        calculated_hash=$(sha1sum "$file_path" | awk '{print $1}')
        ;;
    sha256)
        calculated_hash=$(sha256sum "$file_path" | awk '{print $1}')
        ;;
    *)
        echo "Error: Unsupported hash algorithm. Supported algorithms: md5, sha1, sha256."
        exit 1
        ;;
esac

# Compare hash values
if [ "$hash_value" = "$calculated_hash" ]; then
    echo "✅ True"
else
    echo "❌ False"
fi
