#!/bin/sh

uninstall () {
TODATE=`date --date='today' '+%Y%m%d_%H%M%S'`

##Uninstall OpenNMS##
/opt/opennms/bin/opennms -v stop

rpm -e opennms-1.12.6-1
rpm -e opennms-webapp-jetty-1.12.6-1
rpm -e opennms-core-1.12.6-1

 ##Uninstall Postgres DB##
/sbin/service postgresql-9.3 stop
yum -y remove postgresql93*

##Backup and Purge##

cp -r /opt/opennms/ /opt/opennms_backup_$TODATE
rm -rf /opt/opennms/ 
echo "Backup & Purge OpenNMS ..........................Done!"

cp -r /var/lib/pgsql /var/lib/pgsql_backup_$TODATE
rm -fr /var/lib/pgsql
echo "Backup & Purge Postgresql........................Done!"
}

uninstall | tee -i uninstall.log 
