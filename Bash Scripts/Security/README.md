## Check for failed passwords
```bash
grep -i 'Failed password' /var/log/messages /var/log/secure | awk '{print $11, $1, $2 }'| sort | uniq -c | sort -rn | head -n25 | awk '{print $1, $3, $4, $2 }' | sort -rn
```
