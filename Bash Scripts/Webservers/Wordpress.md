# Find Version
> find /var/www/  -name 'version.php' -path '*wp-includes/*' -printf "%p\t" -exec grep '$wp_version =' {} \; -exec echo '' \; | column -t -s $'\t'
