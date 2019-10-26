#/bin/sh

install_config () {
##Install JDK##
    if rpm -q jdk >/dev/null ; then
        echo "JDK is already installed"
    else
        echo "JDK not installed"
        rpm -ivh jdk-7u55/jdk-*
        echo "JDK Installation..........................DONE!"
   fi
sleep 1

##Install Net-SNMP##
    if rpm -q net-snmp >/dev/null ; then
        echo "NET-SNMP is already installed"
    else
        echo "NET-SNMP not installed"
     rpm -ivh net-snmp-5.7/lm_sensors-libs-3.3.4-11.el7.x86_64.rpm
     rpm -ivh net-snmp-5.7/net-snmp-libs-5.7.2-20.el7.x86_64.rpm
     rpm -ivh net-snmp-5.7/net-snmp-5.7.2-20.el7.x86_64.rpm
     rpm -ivh net-snmp-5.7/net-snmp-utils-5.7.2-20.el7.x86_64.rpm
     echo "Installation NET-SNMP....................DONE!"
    fi
sleep 1

##Install,Setup & Configure Postgres##
    if rpm -q postgresql >/dev/null ; then
        echo "POSTGRESQL is already installed"
    else
        echo "POSTGESQL is not installed"
     rpm -ivh postgres-9.3.10/postgresql93-libs-9.3.10-1PGDG.rhel7.x86_64.rpm
     rpm -ivh postgres-9.3.10/postgresql93-9.3.10-1PGDG.rhel7.x86_64.rpm
     rpm -ivh postgres-9.3.10/postgresql93-server-9.3.10-1PGDG.rhel7.x86_64.rpm
   fi

#Setup:

#Initialize:

#Try this first
#/sbin/service postgresql-9.3 initdb
/usr/pgsql-9.3/bin/postgresql93-setup initdb

#Start PostgreSql when OS starts
/sbin/chkconfig postgresql-9.3 on

#Start the DB
/sbin/service postgresql-9.3 start

#configuration#
cp -v config/pg_hba.conf /var/lib/pgsql/9.3/data/
cp -v config/postgresql.conf /var/lib/pgsql/9.3/data/

#ReStart the DB
/sbin/service postgresql-9.3 restart
echo ""
echo "Installation Postgresql...............................Done!"
sleep 1


##Install OpenNMS##
    if rpm -q jicmp >/dev/null ; then
        echo "JICMP is already installed"
    else
        echo "JICMP is not installed"
    rpm -ivh opennms-1.12.6/jicmp*
     echo "Installation JICMP..........................Done!"
   fi

    if rpm -q opennms >/dev/null ; then
        echo "OPENNMS is already installed"
    else
        echo "OPENNMS is not installed"
    rpm -ivh opennms-1.12.6/opennms-core-1.12.6-1.noarch.rpm
    rpm -ivh opennms-1.12.6/opennms-webapp-jetty-1.12.6-1.noarch.rpm
    rpm -ivh opennms-1.12.6/opennms-1.12.6-1.noarch.rpm
   fi

#Setup
/opt/opennms/bin/runjava -S /usr/java/latest/bin/java
/opt/opennms/bin/install -dis

#Start opennms
/opt/opennms/bin/opennms -v start
sleep 60

#Configure
yes| cp -r config/etc /opt/opennms/
yes | cp -r config/jetty-webapps/opennms /opt/opennms/jetty-webapps/
echo "OpenNMS Configuration....................Done!"


#Restart opennms
/opt/opennms/bin/opennms stop
/opt/opennms/bin/opennms -v start

echo ""
echo "Installation OpenNMS...............................Done!"
}

install_config | tee -i install.log
