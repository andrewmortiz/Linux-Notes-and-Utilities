# Access Log Finder:

>pidof -s httpd -s nginx -s apache -s apache2| tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec  readlink -f {} \; | grep -E "access.*log" | sort | uniq

# Error Log Finder:

>pidof -s httpd -s nginx -s apache -s apache2| tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec  readlink -f {} \; | grep -E "error.*log" | sort | uniq

# Logs with unconventional naming schemes

>pidof -s httpd -s nginx -s apache -s apache2| tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec  readlink -f {} \; | grep -v "^/proc\|^/dev\|^/tmp\|^/etc" | sort | uniq

>pidof -s httpd -s nginx -s apache -s apache2 | tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec  readlink -f {} \; | grep -v "proc" | sort | uniq

# Acceess Log Sort ( awk '{print $1, $7}' (accounts for modifications to default log configuration ) )

>grep "GET\|HEAD\|POST" $(pidof -s httpd -s nginx -s apache -s apache2| tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec readlink -f {} \; | grep -E "access.*log" | sort | uniq) |  awk -F"GET|HEAD|POST|HTTP" '{ ip=$1; gsub(",", "",ip); split(ip, ipa, ":| "); fil=ipa[1]; split(fil, file, "/"); print file[length(file)] " " ipa[2] " ", $2 }' | sort | uniq -c | sort -nr | head -20 | column -t

## With whois attempt ( awk '{print $1, $7}' (accounts for modifications to default log configuration ) )

>out=$(grep "GET\|HEAD\|POST" $(pidof -s httpd -s nginx -s apache -s apache2| tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec readlink -f {} \; | grep -E "access.*log" | sort | uniq) |  awk -F"GET|HEAD|POST|HTTP" '{ ip=$1; gsub(",", "",ip); split(ip, ipa, ":| "); fil=ipa[1]; split(fil, file, "/"); print file[length(file)] " " ipa[2] " ", $2 }' | sort | uniq -c | sort -nr | head -20 | column -t) && loc=$(for i in $(echo "$out" | awk '{print $3}'); do echo " $(whois $i | grep -i country | awk '{print $2}' | tr '[:lower:]' '[:upper:]' | grep "[A-Z][A-Z]" |head -1)";done ) && paste <(echo "$out") <(echo "$loc") | column -t

# Access Log Sort ( automatic awk '{print $1, $7}' ) for Plesk:

>grep "GET\|HEAD\|POST" $(pidof -s httpd -s nginx -s apache -s apache2 | tr -d '\n' | xargs -d " " -I pid find /proc/pid/fd -type l -exec readlink -f {} \; | grep -E "access.*log" | sort | uniq) | awk -F"GET|HEAD|POST|HTTP" '{ ip=$1; gsub(",", "",ip); split(ip, ipa, ":| "); fil=ipa[1]; split(fil, file, "/"); print file[6] " " ipa[2] " ", $2 }' | sort | uniq -c | sort -nr | head -20 | column -t

# Filter IP addresses from a file ( in list form from file named ips ):

>set +H;ips=$(awk 'NF' ips | tr '\n' '|' | sed 's/|$//' | tee); eval "awk '!/"${ips}"|^$/ {print}' file"

Example Usage:

# DDOS Mitigation, filter out already blocked IPs

> set +H;ips=$(awk 'NF' ips | tr '\n' '|' | sed 's/|$//' | tee); eval "awk '!/"${ips}"|^$/ {print}' /var/log/httpd/example.com-access.log" | awk '{print $1, $7}' | sort | uniq -c |sort -nr |head

# OOM

> grep -i 'killed process|invoked oom' /var/log/messages /var/log/syslog 2>/dev/null | grep 'httpd|nginx|apache'

