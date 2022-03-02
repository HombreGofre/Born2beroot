#!/bin/bash
wall    $'#Architecture: ' $(uname -a) \
        $'\n#CPU physical: ' $(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l) \
        $'\n#vCPU: ' $(grep "processor" /proc/cpuinfo | uniq | wc -l) \
        $'\n#Memory Usage: ' $(free -m | awk '$1 == "Mem:" {print $3}')/$(free -m | awk '$1 == "Mem:" {print $2}')'MB' "($(free | awk '$1 == "Mem:" {printf("%.2f", $3/$2*100)}')%)" \
        $'\n#Disk Usage: ' $(df -Bm | grep '/dev/' | grep -v '/boot' | awk '{ud += $3} END {print ud}')/$(df -Bg | grep '/dev/' | grep -v '/boot' | awk '{fd += $2} END {print fd}')'Gb' "($(df -Bg | grep '/dev/' | grep -v '/boot' | awk '{ud += $3} {fd += $2} END {printf("%.2f"), (ud/fd * 100.0)}')%)" \
        $'\n#CPUload: ' $(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{print ($1 + $3)}')'%' \
        $'\n#Last boot: ' $(who -b | awk '{print $3" "$4" "$5}') \
        $'\n#LVM use: ' $(lsblk |grep lvm | awk '{if ($1) {print "yes";exit;} else {print "no"} }') \
        $'\n#Connection TCP:' $(netstat -an | grep ESTABLISHED |  wc -l) \
        $'\n#User log: ' $(who | cut -d " " -f 1 | sort -u | wc -l) \
        $'\nNetwork: IP ' $(hostname -I) "($(ip link show | grep 'link/ether' | awk '{print $2}'))" \
        $'\n#Sudo:  ' $(grep 'sudo' /var/log/auth.log | grep TSID |  wc -l) "cmd"
