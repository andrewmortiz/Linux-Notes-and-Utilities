### These were developed at various points in my career during my time working for an MSP in a never ending quest to get to logs and analyze them as fast as possible. 

## Access Log Finder:
```bash
pidof -s httpd -s nginx -s apache -s apache2| tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec  readlink -f {} \; | grep -E "access.*log" | sort | uniq
```

## Error Log Finder:
```bash
pidof -s httpd -s nginx -s apache -s apache2| tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec  readlink -f {} \; | grep -E "error.*log" | sort | uniq
```
## Logs with unconventional naming schemes
```bash
pidof -s httpd -s nginx -s apache -s apache2| tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec  readlink -f {} \; | grep -v "^/proc\|^/dev\|^/tmp\|^/etc" | sort | uniq
```
```bash
pidof -s httpd -s nginx -s apache -s apache2 | tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec  readlink -f {} \; | grep -v "proc" | sort | uniq
```
## Acceess Log Sort ( awk '{print $1, $7}' (accounts for modifications to default log configuration ) )
```bash
grep "GET\|HEAD\|POST" $(pidof -s httpd -s nginx -s apache -s apache2| tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec readlink -f {} \; | grep -E "access.*log" | sort | uniq) |  awk -F"GET|HEAD|POST|HTTP" '{ ip=$1; gsub(",", "",ip); split(ip, ipa, ":| "); fil=ipa[1]; split(fil, file, "/"); print file[length(file)] " " ipa[2] " ", $2 }' | sort | uniq -c | sort -nr | head -20 | column -t
```

## With whois attempt ( awk '{print $1, $7}' (accounts for modifications to default log configuration ) )
```bash
out=$(grep "GET\|HEAD\|POST" $(pidof -s httpd -s nginx -s apache -s apache2| tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec readlink -f {} \; | grep -E "access.*log" | sort | uniq) |  awk -F"GET|HEAD|POST|HTTP" '{ ip=$1; gsub(",", "",ip); split(ip, ipa, ":| "); fil=ipa[1]; split(fil, file, "/"); print file[length(file)] " " ipa[2] " ", $2 }' | sort | uniq -c | sort -nr | head -20 | column -t) && loc=$(for i in $(echo "$out" | awk '{print $3}'); do echo " $(whois $i | grep -i country | awk '{print $2}' | tr '[:lower:]' '[:upper:]' | grep "[A-Z][A-Z]" |head -1)";done ) && paste <(echo "$out") <(echo "$loc") | column -t
```
## Access Log Sort ( automatic awk '{print $1, $7}' ) for Plesk:
```bash
grep "GET\|HEAD\|POST" $(pidof -s httpd -s nginx -s apache -s apache2 | tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec readlink -f {} \; | grep -E "access.*log" | sort | uniq) | awk -F"GET|HEAD|POST|HTTP" '{ ip=$1; gsub(",", "",ip); split(ip, ipa, ":| "); fil=ipa[1]; split(fil, file, "/"); print file[6] " " ipa[2] " ", $2 }' | sort | uniq -c | sort -nr | head -20 | column -t
```

## Filter IP addresses from a file ( in list form from file named ips ):
```bash
set +H;ips=$(awk 'NF' ips | tr '\n' '|' | sed 's/|$//' | tee); eval "awk '!/"${ips}"|^$/ {print}' file"
```

## DDOS Mitigation, filter out already blocked IPs
```bash
set +H;ips=$(awk 'NF' ips | tr '\n' '|' | sed 's/|$//' | tee); eval "awk '!/"${ips}"|^$/ {print}' /var/log/httpd/example.com-access.log" | awk '{print $1, $7}' | sort | uniq -c |sort -nr |head
```

## OOM
```bash
grep -i 'killed process|invoked oom' /var/log/messages /var/log/syslog 2>/dev/null | grep 'httpd|nginx|apache'
```

## Older Alert Panther one liner 
```bash
ALL=$(awk '/POST|GET/ && !/Monitor|dummy connection|server-status|127.0.0.1|localhost|^  -/  {print $0}' <(grep -P '^\d+(\.\d+){3}\s' $(lsof | awk '/httpd|nginx|apache2/ && /access/ && /log/ && !a[$9]++ {print $9}' 2>/dev/null) ) | awk '{print $1}' | awk -F":" '{print $2}' | sort | uniq -c | sort -nr | head -25) && IPS=$(awk '{print $2}' <<< "$ALL" | tr -d ,) &&  COUNTRY=$(for i in $(echo "$IPS"); do tmpwho=$(whois $i) && tmpwhoflag=0 && if [[ "$tmpwho" =~ .*IANA.* ]]; then echo "Private" && tmpwhoflag=1; fi && if ( [[ $(grep -ic country "$tmpwho" 2>&1) == 0 ]] && [ "$tmpwhoflag" -eq 0 ]); then echo "Unknown" && tmpwhoflag=1 ; fi && if [[ "$tmpwhoflag" -eq 0 ]]; then grep -i country <(echo "$tmpwho") 2>&1 | tail -1 | awk '{print $2}' && tmpwhoflag=1; fi && if [[ "$tmpwhoflag" -eq 0 ]]; then echo "Unknown"; fi; done) && paste -d " " <(echo "$COUNT") <(echo "$IPS") <(echo "$COUNTRY") | column -t
```
  
## Apache Semaphores
```bash
for semid in \`ipcs -s | grep apacheusername | cut -f2 -d “ “\` ; do ipcrm -s $semid ; done
```
