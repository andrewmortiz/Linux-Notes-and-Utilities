# Find Version
> find /var/www/  -name 'version.php' -path '*wp-includes/*' -printf "%p\t" -exec grep '$wp_version =' {} \; -exec echo '' \; | column -t -s $'\t'

## Install 
>   curl -L wordpress.org/latest.tar.gz | tar xvz --strip 1; find . -type d -print0 | xargs -0 chmod 2775; find . -type f -print0 | xargs -0 chmod 0664
