echo "Start Time:" && read as && echo "End Time:"  && read ae && hb=$(date -d"$(echo "$as")" +%d/%b/%Y:%H:%M:%S) && ha=$(date -d"$(echo "$ae")" +%d/%b/%Y:%H:%M:%S) && fil=$(for i in $(lsof | awk '/httpd|nginx|apache2/ && /access/ && /log/ && !a[$9]++ {print $9}' 2>/dev/null); do awk -v  hb=$hb -v ha=$ha -v prefix="$i:" -F"[" '$2>hb && $2<ha && !/Monitor|dummy connection|server-status|127.0.0.1|localhost|^ -/ && /POST|GET/ $0 && gsub(/\,/,"",$1)1 {print prefix $0}' $i; done) && p1=$( awk '{print $1}' <<< "$fil") &&   p2=$(awk '{for(i=1;i<=NF;i++)if($i~/POST|GET/)print $(i+1)}' <<< "$fil") && ao=$(paste -d " " <(echo "$p1") <(echo "$p2") | awk '{ cnts[$0] += 1 } END { for (v in cnts) print cnts[v], v | "sort -nr | head -50 "}') &&  ips=$(for i in $(awk '{print $2}' <<< "$ao" | awk -F":| " '{print $2}'); do curl -s https://www.bitlebowski.com/ip/index.php?ip=$i; done) && p3=$(paste <(echo "$ao") <(echo "$ips") --d ' ' | column -t -s $'\t ') && echo "Top hits by target and ip address from $hb to $ha" &&  paste -d " " <(awk '{print $1}' <<< "$p3" ) <(awk '{print $2}' <<< "$p3" | awk -F ":" '{print $1}' | awk -F"/" '{print $NF}') <(awk '{print $2}' <<< "$p3" | awk -F ":" '{print $2}') <(awk '{print $3, $4}' <<< "$p3") | column -t -s $'\t '