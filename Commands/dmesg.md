# Human-Readable Timestamps when dmest -T is unavailable
```bash
date_format="%a %b %d %T %Y";
uptime=$(cut -d " " -f 1 /proc/uptime);
if [ "Y" = "$(cat /sys/module/printk/parameters/time)" ]; then
  dmesg | sed "s/^\[[ ]*\?\([0-9.]*\)\] \(.*\)/\\1 \\2/" | while read timestamp message; do
    printf "[%s] %s\n" "$(date --date "now - $uptime seconds + $timestamp seconds" +"${date_format}")" "$message";
  done;
else
  echo "Timestamps are disabled (/sys/module/printk/parameters/time)";
fi;
```
