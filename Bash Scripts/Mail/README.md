## PHP-Script-MailQ-Hunter (mailq/postcat)
```bash
for i in $(mailq | awk '{print $1}' | sed '/\@/d' | sed '/^$/d' | grep -v "^(\|--" | tail -2000 ); do postcat -vq $i 2>&1 | grep 'PHP'; done | sort |  uniq -c | sort -nr
```
