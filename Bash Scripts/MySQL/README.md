## Disk Usage Per Database
```bash
mysql -e "SELECT table_schema 'Data Base Name', sum( data_length + index_length ) / 1024 / 1024 'Data Base Size in MB' FROM information_schema.TABLES GROUP BY table_schema ;"
```
## Query Types from Binlogs
```bash
clear; unset binlogname; binlogname=$(for list in $(grep log-bin /etc/my.cnf|awk -F'=' '{print $2}');do ls -ltrh $list*[^index] 2> /dev/null|tail -n1|awk '{print $9}';done); for databasename in $(mysqlbinlog ${binlogname} | grep ^use | grep -oE '`.*`' | sort -u | sed 's/`//g') ; do echo -e "[b]------------------------------------------\nDATABASE NAME:  ${databasename}\n------------------------------------------[/b]" ; mysqlbinlog ${binlogname} | sed -n "/use \`${databasename}\`/,/use \`/p" | tr '[:upper:]' '[:lower:]' | awk '/^updat|^inser|^delet|^replac|^alte/ {print $1,$2,$3}' | sort | uniq -c | sort -nr | head -50 || echo "NO QUERIES" ; done
```
## Database Engines and Size
```bash
mysql -A -e 'select engine,sum(index_length+data_length)/1024/1024,count(engine) from information_schema.tables group by engine;'
```
## Largest 25 MySQL Tables
```bash
#https://www.percona.com/blog/2008/02/04/finding-out-largest-tables-on-mysql-server/
mysql>
SELECT CONCAT(table_schema, '.', table_name),
 CONCAT(ROUND(table_rows / 1000000, 2), 'M') rows,
 CONCAT(ROUND(data_length / ( 1024 * 1024 * 1024 ), 2), 'G') DATA,
 CONCAT(ROUND(index_length / ( 1024 * 1024 * 1024 ), 2), 'G') idx,
 CONCAT(ROUND(( data_length + index_length ) / ( 1024 * 1024 * 1024 ), 2), 'G') total_size,
 ROUND(index_length / data_length, 2) idxfrac
FROM information_schema.TABLES
ORDER BY data_length + index_length DESC
LIMIT 25;
```
## MySQL Seconds Behind Master
```bash
echo "show slave status\G"|mysql -S /var/lib/mysql/mysql.sock | grep Seconds_Behind_Master
```



