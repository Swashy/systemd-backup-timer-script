#!/bin/bash

#TO DO:
#Compare all contents of each file on really low priority with nice for ultimate injection paranoia

theDate=$(date "+%F")
backupFile="wordpress.bak.$theDate.tar.gz"
#mysql dump by connecting with our options login file
mysqldump --defaults-file=/root/wordpress-backup/.login.cnf wpdatabase > /var/www/html/mariadb-backup.d/db-bak.$theDate
tar --xattrs -czpvf /var/www/html/$backupFile /var/www/html/wordpress/ /var/www/html/mariadb-backup.d/ /var/www/html/wp-secure.d/
#Debug. Give us notice that the timer actually ran

tarList=$(tar -tvf /var/www/html/$backupfile)
#tail the last line, which will have the last backup file name in it surrounded by quotes. Cut them out.
lastBackupFile=$(tail -n 1 backup-notice.log | cut -d\" -f2-2)
tarListOld=$(tar -tvf /var/www/html/$lastBackupFile)

#Get the differences. the Strange echo syntax is how we diff variables in memory. -s will tell us if the tars have identical files listed
difference=$(diff -s <(echo "$tarList") <(echo "$tarListOld"))

#Touch does nothing if a file is there
touch /var/www/html/backup-notice.log
echo "/etc/systemd/system/wordpress-backup.service ran at $theDate" >> /var/www/html/backup-notice.log
echo "***Differences are:***/n$difference" >> /var/www/html/backup-notice.log
echo "***End Differences***" >> /var/www/html/backup-notice.log
echo "File made was \"$backupFile\"" >> /var/www/html/backup-notice.log
 

