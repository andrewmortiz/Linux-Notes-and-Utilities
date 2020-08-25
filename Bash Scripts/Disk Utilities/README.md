## List Bind Mounts:
```bash
findmnt | grep ".*]"
```
## Check for unmounted disks /proc/mounts vs fstab
```bash
for item in `cat /etc/fstab | awk '{print $1}' | grep -v "#"`; do
    if [[ $(grep $item /proc/mounts) ]]; then
    printf "    mounted: "; echo $item
    else
    printf "NOT MOUNTED: "; echo $item
    fi
done
```
