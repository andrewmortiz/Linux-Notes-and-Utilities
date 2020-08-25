# Processes by RAM consumption
> ps -eo user,%cpu,%mem,rsz,args|sort -rnk4|awk 'BEGIN {printf "%8s %6s %6s %8s %-10s\n","USER","%CPU","%MEM","RSZ",\
"COMMAND"}{printf "%8s %6s %6s %8s MB %-10s\n",$1,$2,$3,$4/1024,$5}' | head -n1011)
