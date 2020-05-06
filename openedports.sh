#!/bin/bash

if [ $1 == "-help" ] || [ $1 == "--h" ]; then
    echo "Syntax is: ./openedports.sh <IPs first 24 bit> "
    echo "       Ex: ./openedports.sh 192.168.1 "
else

for ip in `seq 1 254` ; do
    ping -c 1 $1.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> addresses.txt &
done

echo "Existed Machines"
echo "------------------"
cat addresses.txt
printf "\n\n\nOpened Ports\n"
echo "--------------"


for ip in $(cat addresses.txt) ; do
    echo "IP:$ip"
    printf "Brand: "
    nmap -sS -p 21 -T4 -Pn $ip | grep "MAC" | cut -d " " -f 4 | tr -d "(" | tr -d ")"
    printf "OS: "
    nmap -O $ip | grep "Running:" | cut -d " " -f 2
    printf "\n"
    nmap -sS -p 21-445 -T4 -Pn $ip | grep "open"
    echo "-------------"
    echo ""
done

rm addresses.txt
fi
