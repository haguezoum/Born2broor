#!/bin/bash
MemAvail=$(cat /proc/meminfo | grep MemAvailable | awk '{printf "%d", $2/1000}')
MemTotal=$(cat /proc/meminfo | grep MemTotal 	 | awk '{printf "%d", $2/1000}')
MemUsage=$((MemTotal - MemAvail))
DisAvail=$(df --total -m | grep total | awk '{printf "%d", $4}')
DisTotal=$(df --total -h | grep total | awk '{printf "%d", $2}')
DisUsage=$(df --total -h | grep total | awk '{printf "%d", $3}')
CPU=$(top -n 1| grep '%Cpu' | awk '{printf "%s", $2 + $4 + $10 }')
LastBoot=$(who -b | awk '{printf("%s %s\n", $3 , $4)}')
LVM=""
if [ -d "/etc/lvm" ]; then
	LVM="yes"
else
	LVM="no"
fi
TCPcnx=$(ss -t | grep 'ESTAB' | wc -l)
UserLog=$(who |cut -d" " -f1 | sort | uniq | wc -l)
IP=$(hostname -I)
MAC=$(cat /sys/class/net/enp0s3/address)
SUDOcmd=$(journalctl _COMM=sudo -q | grep COMMAND |wc -l)

echo "#Architecture : "$(uname -a)
echo "#CPU physical : "$(lscpu | grep Socket | awk '{print $2}')
echo "#vCPU : "$(cat /proc/cpuinfo | grep processor |  wc -l )
printf "#Memory Usage : %s/%sMB (%.2f%%)\n" $MemAvail $MemTotal  $(($MemUsage*100/$MemTotal))
printf "#Disk Usage : %d/%dGb (%.2f%%)\n" $DisAvail $DisTotal $((DisUsage*100/DisTotal))
printf "#Cpu load : %s%%\n" $CPU
printf "#Last boot: %s %s\n" $LastBoot
printf "#Use LVM : %s\n" $LVM
printf "#Connection TCP  %s ESTABLISHED\n" $TCPcnx
printf "#User log: %s\n" $UserLog
printf "#Sudo : %s\n" $SUDOcmd