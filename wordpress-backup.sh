#1/bin/bash
theDate=$(date "+%F")
backupFile="wordpress.bak.$theDate.tar.gz" 
tar --xattrs -czpvf /var/www/html/$backupFile /var/www/html/wordpress/
#Debug. Give us notice that the timer actually ran
touch /var/www/html/backup-notice.log
echo "/etc/systemd/system/wordpress-backup.service ran at $theDate" > /var/www/html/backup-notice.log
