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
## Reserve Block Percentage 
```bash
for i in $(mount | grep -Eiv 'type tmpfs|type cgroup|type mqueue|type debug|type fuse|type sys|type proc|type dev|type sec|type hug|type pstor|type aut|type bin|type con|type sel|type none|type nfs|type rpc_pipefs' | awk '{print $1}');
 do echo "------- $i -------";
  tune2fs -l $i| grep -E '^Block count:|^Reserved block count:|^Last mounted on:';
  intTotalBlocks=$(tune2fs -l $i | grep -E '^Block count:' | awk '{print $3'});
  intReserveBlocks=$(tune2fs -l $i | grep -E '^Reserved block count:' | awk '{print $4'});
  echo "[b]Reserve = $(echo "scale=4; $intReserveBlocks * 100  / $intTotalBlocks" | bc)%[/b]";
done;
```
