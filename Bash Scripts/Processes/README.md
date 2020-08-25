## High CPU Usage
```bash
resize;clear;echo;date;echo "Top 10 Processes by CPU %";echo ""; ps -eo user,%cpu,%mem,rsz,args,pid,lstart|sort -rnk2|awk 'BEGIN {printf "%12s\t%s\t%s\t%s\t%s\n","USER","%CPU","%MEM","RSZ","COMMAND","PID","Started"}{printf "%12s\t%g'%'\t%g'%'\t%d MB\t%s\n",$1,$2,$3,$4/1024,$5}'|head -n10;echo; echo "== Last 90 mins ==";echo;sar|head -n3;sar -u|tail -n10;echo;sar -q|head -n3;sar -q|tail -n10;echo;echo "== Current 5 Second Intervals ==";echo;sar -u 5 12;echo;sar -q 5 12
```

## Processes by RAM consumption
```bash
ps -eo user,%cpu,%mem,rsz,args|sort -rnk4|awk 'BEGIN {printf "%8s %6s %6s %8s %-10s\n","USER","%CPU","%MEM","RSZ",\
"COMMAND"}{printf "%8s %6s %6s %8s MB %-10s\n",$1,$2,$3,$4/1024,$5}' | head -n1011)
```
### Detailed 
```bash
tempfile=$(mktemp) ; coproc sar -B -r -o $tempfile 1 10 >/dev/null; resize; clear; echo "== Server Time: =="; date '+%F %r'; echo -e "\n== Memory Utilization Information: =="; awk '{ if ($1 == "MemTotal:") { TOTAL =$2/1024} if ($1 == "MemFree:") { FREE =$2 } if ($1== "Buffers:") { BUFFERS =$2 } if ($1 == "Cached:" ) { CACHE = $2 } USED = TOTAL-(FREE+BUFFERS+CACHE)/1024 } END {printf "Total Memory\tActive Memory\tPercentage Used\n%dM\t\t%dM\t\t%.2f%%\n",TOTAL,USED,USED/TOTAL * 100; }' /proc/meminfo; echo -e "\n== Current Swap Usage: =="; swapon -s | sed 1d | awk 'BEGIN { print "DEVICE\t\tUSED\t\tTOTAL\t\tPERCENT USED"; } { DEVICE=$1; TOTAL=($3/1024); USED=($4/1024); PERCENT=((USED/TOTAL)*100); printf "%s\t%.2fM\t%.2fM\t%.2f%%\n",DEVICE,USED,TOTAL,PERCENT; }' | column -s$'\t' -t; echo -e "\n== Top 10 Processes by Memory Usage: =="; ps -eo user,pid,%mem,rsz,args --sort=-rsz | head -11 | awk '{print $1,$2,$3,$4,$5}' | column -t; echo -e "\n== Top 10 Processes By Swap Usage: =="; ( printf "%s\t%s\t%s\n" "PID" "PROCESS" "SWAP"; (for i in /proc/[0-9]*; do PID=${i#/proc/}; NAME=$(awk '/Name/ {print $2}' ${i}/status 2>/dev/null); SWAP=$(awk '/Swap/ { sum+=$2 }; END { print sprintf("%.2f", sum/1024) "M" }' /${i}/smaps 2>/dev/null);echo ${PID} ${NAME} ${SWAP}; done | awk '!/0.00M/' |sort -grk3,3 | head -10)) | column -t; echo -e "\n== Top 10 Kernel Slab Caches: =="; ( echo "SIZE NAME"; slabtop -o -s c | sed 1,7d | head -10 | awk '{ printf "%.2fM\t%s\n",gensub(/K$/,"","g",$(NF-1))/1024,$NF; }' ) | column -t; echo -e "\n== Last 30 Minutes Memory Usage: =="; sar -r -s $(date --date='-50 minutes' +%T) | sed 1,2d; echo -e "\n== Last 30 Minutes Paging/Swap Statistics: =="; sar -B -s $(date --date='-50 minutes' +%T) | sed 1,2d; wait 2>/dev/null; echo -e "\n== Current 1 Second Memory Usage Statistics (10 Count): =="; sar -r -f $tempfile | sed 1,2d; echo -e "\n== Current 1 Second Paging/Swap Statistics (10 Count): =="; sar -B -f $tempfile | sed 1,2d; if [[ -f $tempfile ]]; then rm -f $tempfile; fi
```

## D State
```bash
find -maxdepth 2 -name stat -exec cat {} \; | awk '{print$1,$2,$3}' | grep D
```
```bash
find -maxdepth 2 -name stat -exec cat {} \; | awk '{print$1,$2,$3}' | grep D | wc -l
```
