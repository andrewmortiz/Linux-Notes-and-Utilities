#!/bin/sh
# Used to profile disk layout for a manual replication of a server
echo "Physical Mounts:"
grep -v "vg\|nfs" /etc/fstab | grep "^/"| while read -r line; do
        size=$(df -h "$(echo "$line" | awk '{print $1}')" | grep -v "^F" | awk '{print $2}')
        echo "$line Size:$size"
        done
echo -e "\nLogical Volumes/Mounts:" 
while read -r vgname lvname lvpath lvsize; do ismounted=$(findmnt "$lvpath" -otarget -n); if [[ -n $ismounted ]]; then echo "$vgname $lvname $ismounted $lvsize"; fi; done < <(lvs --no-headings -o vg_name,lv_name,lvpath,lv_size)

echo -e "\nNFS Mounts:" 
grep nfs /etc/fstab | grep -v "^#"
echo ""

