#!/bin/sh

PKGSTOINSTALL_DEBIAN="
acl apache2 apache2-suexec-pristine apache2-dev apache2-doc apache2-utils autoconf automake 
basex bzip2 build-essential bison binutils 
curl chrpath 
debhelper 
expect 
freetds-common freetds-bin flex 
git git-core graphviz 
imagemagick 
libapache2-mod-fcgid libapache2-mod-php5 libruby libapache2-mod-python libcurl3 libssl-dev libfontconfig1-dev libxft-dev libapache2-mod-fastcgi libtool 
mariadb-client mariadb-server memcached mcrypt mercurial meld 
ntp ntpdate nodejs 
openssl openssh-server 
php-auth 
php5 
php5-dev 
php5-common php5-curl php5-cli php5-cgi 
php5-gd 
php5-intl php5-imagick php5-imap 
php5-mysql php5-mcrypt php5-memcache php5-memcached php5-ming 
php5-ps php5-pspell php-pear 
php5-recode 
php5-tidy 
php5-snmp php5-sqlite php5-sybase 
php5-ldap 
php5-fpm 
php5-xcache php5-xmlrpc php5-xsl
phpmyadmin python-yaml python3-yaml python-software-properties python-tk python3-tk 
sudo ssh snmp 
tree 
vim-nox 
unzip unixodbc 
zip 
"

PKGSTOINSTALL_REDHEAD="
acl apache2 apache2-suexec-pristine apache2-dev apache2-doc apache2-utils autoconf automake 
basex bzip2 build-essential bison binutils 
curl chrpath 
debhelper 
expect 
freetds-common freetds-bin flex 
git git-core graphviz 
imagemagick 
libapache2-mod-fcgid libapache2-mod-php5 libruby libapache2-mod-python libcurl3 libssl-dev libfontconfig1-dev libxft-dev libapache2-mod-fastcgi libtool 
mariadb-client mariadb-server memcached mcrypt mercurial meld 
ntp ntpdate nodejs 
openssl openssh-server 
php-auth 
php5 php56w 
php5-dev php56w-devel php56w-dba 
php5-common php5-curl php5-cli php5-cgi php56w-cli php56w-common 
php5-gd php56w-gd 
php5-intl php5-imagick php5-imap php56w-imap php56w-interbase php56w-intl 
php5-mysql php5-mcrypt php5-memcache php5-memcached php5-ming php56w-mbstring php56w-mcrypt php56w-mssql php56w-mysql php56w-mysqlnd 
php5-ps php5-pspell php-pear 
php5-recode 
php5-tidy 
php5-snmp php5-sqlite php5-sybase php56w-snmp php56w-soap 
php5-ldap php56w-ldap 
php5-fpm php56w-fpm 
php5-xcache php5-xmlrpc php5-xsl php56w-xml php56w-xmlrpc 
php5-odbc php56w-opcache php56w-odbc
phpmyadmin python-yaml python3-yaml python-software-properties python-tk python3-tk php56w-pdo php56w-pear 
sudo ssh snmp 
tree 
vim-nox 
unzip unixodbc 
zip 
"