    Spin up a Cloud Load Balancer, two web servers( web01 and web02 ), and two database servers ( db01 and db02 ).
        Utilize Cloud Servers, not Cloud Database instances.
    Point DNS or your /etc/hosts file to web01.
    Install a LAMP stack and Wordpress on web01.
        go to www.example.com and run through the setup process. 
    Migrate the database from web01 to db01.
         Hint
    Setup SSL for your Wordpress site ( you can use a self-signed SSL cert if needed ).
    Set up lsyncd to sync the Wordpress web directories across web01 and web02
    Test that web02 loads correctly without changing DNS using curl.
         Hint
    Put both web01 and web02 behind a load balancer and then switch DNS to point to the load balancer.
        Terminate SSL on the load balancer.
            Load the site over https://
            upload an image
                fix the mixed-content error.
                     Hint
        Modify your apache logs to show the source IP address and not the load balancer's IP address in the apache logs.
    Install and configure varnish.
        Modify the default.vcl to ensure any requests for the wp-admin go to the master.
    Secure the Wordpress admin page with an .htaccess / .htpasswd file that requires a username and password.
    Modify the virtual host for your domain to limit access to the admin page from your workstation IP address or the bastion IP address if you are proxying traffic.
    Create a subdomain for your site such as dev.example.com and copy the web files from your Wordpress site to a new directory such as /var/www/vhosts/dev.example.com
    Create a mysqldump and import it to dev_yoursite and point the wp-config from the dev.example.com site to the dev_yoursite.
    Try to load https://dev.example.com
        Make sure that it is secure
        Make sure it does not redirect to the example.com site.
    Setup replication from db01 to db02.
        What binlog format should you use and why?
    Setup a backup solution to run backups on db02.
    Create two storage volumes and attach one to each database server. 
        Create the folder /data and mount the storage volumes to it.
        Make this the new datadir for mysql.
    Create a new site, magento.example.com and install Magento 2.
        Identify the location of the following and understand what they do.
            system.log
            exception.log
            env.php
            the location where numbered exceptions occur
        delete the cache and session folders
    Create a dev site for the Magento 2 site and solve the same issues you encountered with Wordpress.
        install Redis and modify the Magento 2 installation to use Redis
    Create a chrooted sftp user with a bind mount to your dev Wordpress site.
    Modify your www.example.com vhosts to have the log files in /var/www/vhosts/www.example.com/logs/access_log
    Install logrotate and ensure it rotates the above file
        force a logrotate to occur to test
    Install recap ( google rackspace recap ) on the web servers and db servers and ensure the db servers include a full processlist run on mysql. 
    Install ClamAV and Maldet and have them both run a scan on your web directories
    The lsyncd / varnish configuration is no longer working out for the customer.  Convert this to an NFS configuration.
    Create a new server ( 4GB or greater )
        Get a trial of Plesk and install it on the server.
        Create a Wordpress site through Plesk and install an SSL Cert on it
            Also identify how to set a default cert for a specific IP address on Plesk
        Use the Plesk command line tool to repair vhost permissions to Plesk default
    Your Wordpress site may have been attacked!
        Find or construct a one liner to count the number of requests by an IP address providing an output such as
                50     50.1.5.23      /wp-login.php
        Modify it it only output the IP addresses
        Modify it to only look for the request.
    Take a mysqldump of db02 in a screen session.
    Send yourself an e-mail from your server.
        If you sent it to g-mail and it bounced.  Troubleshoot why.
        If you have have your own domain, send yourself an e-mail back
    Reboot all your servers and make sure it all still works.

Bonus Rounds:

    Do the Wordpress / Magento setup with nginx instead of Apache.
    Setup nginx as the load balancer instead of utilizing a native load balancer.
