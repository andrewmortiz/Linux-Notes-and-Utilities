## Filio's strace magic
```bash
$(ps -efww|grep http|grep -v root | awk '{print $2}'|tr '\n' ' '|sed -e 's/ / -p /g' | sed -e 's/^/strace -eopen,write,read,accept -s10000 -o strace.log -t -ff -p /' | sed -e 's/-p $//')
```
    
