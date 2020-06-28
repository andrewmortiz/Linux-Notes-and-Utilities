#!/bin/bash
#Usage lowdish.sh filesystem 
filesystem="$1"
echo "Disk Usage for ${filesystem}:"
df -h ${filesystem}
if command -v vgs > /dev/null; then
	echo "Volume Group Usage:"
	vgs $(df -h $filesystem | grep dev | awk '{print $1}' | cut -d\- -f1| cut -d\/ -f4)
fi
echo ""
echo "Largest Directories:"
du -xSk $filesystem 2>/dev/null | sort -rnk1 | head -20 | awk '{printf "%d MB %s\n", $1/1024,$2}'
echo ""
echo "Largest Files:"
find $filesystem -mount -type f -ls | sort -rnk7 | head -20 | awk '{printf "%d MB\t%s\n",($7/1024)/1024,$NF}'
odf=$(lsof 2>/dev/null| grep $filesystem | grep deleted| awk '{ print $7/1048576, "MB ",$9,$1 }' | sort -n | uniq | tail)
if [ "$odf" ]; then echo -e "\nOpen Deleted Files:\n$odf";fi