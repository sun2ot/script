#!/bin/bash

nameservers="nameserver 223.5.5.5
nameserver 119.29.29.29"

original_content=$(cat /etc/resolv.conf)

echo "$nameservers" > /tmp/new_resolv.conf
echo "$original_content" >> /tmp/new_resolv.conf

sudo cp /tmp/new_resolv.conf /etc/resolv.conf

rm /tmp/new_resolv.conf

echo "nameservers added to /etc/resolv.conf"

