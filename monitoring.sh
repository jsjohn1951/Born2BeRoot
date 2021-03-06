#!/bin/bash

#Architecture :: Command: uname -a
echo "#Architecture: " | tr -d '\n' && uname -a

#Physical Processors
echo "#CPU physical : " | tr -d '\n' && nproc

#Virtual Processors
echo "#vCPU : " | tr -d '\n' && cat /proc/cpuinfo | grep processor | awk '{print $3}'

#Ram and utilization
echo "#Memory Usage: " | tr -d '\n' && free -m | grep Mem: | awk '{printf($3 "/" $2 "MB (")}'
free -m | grep Mem: | awk '{printf($3/$2*100)}' | cut -c -4 | tr -d '\n'
echo "%)"

#Disk Usage
echo "#Disk Usage: " | tr -d '\n' && df -h --total | grep total | awk '{printf $3}' | cut -c -3 | tr -d '\n'
echo "/" | tr -d '\n' && df -h --total | grep total | awk '{printf($2 "b (" $5 "%)\n")}'

#CPU Load
#Have to "$sudo apt-get install sysstat" in order to use mpstat command for cpu load
#Take 100 - %idle processes in order to calculate the total cpu load
echo "#CPU Load: " | tr -d '\n' && mpstat | grep all | awk '{printf(100-$13) "%%\n"}'

#Last Reboot
echo "#Last Boot: " | tr -d '\n' && uptime -s

#LVM active
#lsblk, grepping and counting all the instances of "lvm" with wc -l
#If wc -l returns == 0 then print no else print yes
lvmt=$(lsblk | grep "lvm" | wc -l)
echo "#LVM use: " | tr -d '\n'
if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi

#Number of active connections
#Have to "$sudo apt-get install net-tools" to use the netstat command
echo "#Connections TCP: " | tr -d '\n'
netstat | grep ESTABLISHED | wc -l | tr -d '\n'
echo " ESTABLISHED"

#Number of users using server
echo "#User log: " | tr -d '\n' && users | wc -w

#Network IP and Mac Address
echo "#Network: IP " | tr -d '\n' && hostname -I | tr -d '\n' && echo " (" | tr -d '\n' && ip a | grep link/ether \
| awk '{printf($2)}' && echo ")"

#number of commands executed with sudo
echo "#Sudo: " | tr -d '\n' && journalctl _COMM=sudo -q | grep COMMAND | wc -l | tr -d '\n'
echo " cmd"
