#!/bin/sh

if [ -f includes/packages.sh ]; then
	. $DIR/includes/packages.sh
fi

MONGODB_VERSION=3.2.0

show_help() {
cat << EOF
Usage: $(basename "$0") [-h] [-i] [-m user pass new_pass] [-p] [-a host user pass new_pass dbname] [-c host user pass dbname] ...

Приятно ползване.

Option      GNU long option     Meaning
 -h, -?      --help              Show this help text.
 -a          --auto              Install all.
 -c          --composer          Install Composer.
 -j          --jdk               Install Java Development Kit.
 -m          --mongodb           Install MongoDB.
 -d          --dotNet            Install MonoDevelop.
 -p          --packages          Install only Packages.
 -k          --komodo            Install Komodo Editor.
 -w          --web               Install Framework.
             --drush             install Drush for Drupal
EOF
}


autoInstallAll(){
    installPKG
    sudo npm install bower -g
    . ./includes/env.sh
    installExtra
}

installExtra(){
    installJDK
    installComposer
    installFrameworkPHP
    installMongodb
    installMonodevelop
    installKomodo
    installAudacious
    installGoogleChrome
    installSublimeText
    installPhuml
    installDrush
}

installPKG(){
	if [ "$PKGSTOINSTALL" != "" ]; then
		echo -n "Some dependencies are missing. Want to install them? (Y/n): "
		read SURE
		if [[ $SURE = "Y" || $SURE = "y" ]]; then
            if which apt-get &> /dev/null; then
				apt-get install -y $PKGSTOINSTALL_DEBIAN
				a2enmod rewrite suexec ssl actions include cgi dav_fs dav auth_digest
				php5enmod mcrypt
                a2enmod actions fastcgi alias 
				apache_mime_type
                if grep -q -R 'ServerName' /etc/apache2/apache2.conf;
                then
                    echo -e "$(grep 'ServerName' /etc/apache2/apache2.conf)\n"
                    sed -i 's/#ServerName/ServerName/' /etc/apache2/apache2.conf
                else
                    echo 'ServerName 127.0.0.1' >> /etc/apache2/apache2.conf
               fi
               service apache2 restart
            elif which yum &> /dev/null; then
                installRPMPackages
				yum install -y $PKGSTOINSTALL_REDHEAD
                yum replace php-common --replace-with=php56w-common
                systemctl enable httpd.service
                systemctl start httpd.service
                firewall-cmd --permanent --zone=public --add-service=http
                systemctl restart firewalld.service
                installScriptForApache
            fi
        fi
    fi
}

installRPMPackages(){
    sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
}

installScriptForApache(){
    mkdir /etc/httpd/sites-available sites-enabled
    
    echo 'IncludeOptional sites-enabled/*.conf' >> /etc/httpd/conf/httpd.conf
    
    touch /etc/httpd/sites-available/default.conf
    echo '<VirtualHost *:80>
        ServerName localhost
        DocumentRoot "/var/www"
                <Directory "/var/www">
                Options Indexes FollowSymLinks MultiViews
         # AllowOverride controls what directives may be placed in .htaccess files.      
                        AllowOverride All
        # Controls who can get stuff from this server file
                        Order allow,deny
                        Allow from all
           </Directory>
        <IfModule mpm_peruser_module>
                ServerEnvironment apache apache
        </IfModule>
        ErrorLog  /var/log/httpd/error.log
        CustomLog /var/log/httpd/access.log combined
</VirtualHost>' >> /etc/httpd/sites-available/default.conf

    touch /usr/local/bin/a2ensite
    echo '#!/bin/bash
if test -d /etc/httpd/sites-available && test -d /etc/httpd/sites-enabled  ; then
echo "-----------------------------------------------"
else
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled
fi

avail=/etc/httpd/sites-available/$1.conf
enabled=/etc/httpd/sites-enabled/
site=`ls /etc/httpd/sites-available/`

if [ "$#" != "1" ]; then
                echo "Use script: a2ensite virtual_site"
                echo -e "\nAvailable virtual hosts:\n$site"
                exit 0
else

if test -e $avail; then
sudo ln -s $avail $enabled
else

echo -e "$avail virtual host does not exist! Please create one!\n$site"
exit 0
fi
if test -e $enabled/$1.conf; then

echo "Success!! Now restart Apache server: sudo systemctl restart httpd"
else
echo  -e "Virtual host $avail does not exist!\nPlease see available virtual hosts:\n$site"
exit 0
fi
fi' >> /usr/local/bin/a2ensite

    touch /usr/local/bin/a2dissite
    
    echo '#!/bin/bash
avail=/etc/httpd/sites-enabled/$1.conf
enabled=/etc/httpd/sites-enabled
site=`ls /etc/httpd/sites-enabled/`

if [ "$#" != "1" ]; then
                echo "Use script: a2dissite virtual_site"
                echo -e "\nAvailable virtual hosts: \n$site"
                exit 0
else

if test -e $avail; then
sudo rm  $avail
else
echo -e "$avail virtual host does not exist! Exiting!"
exit 0
fi

if test -e $enabled/$1.conf; then
echo "Error!! Could not remove $avail virtual host!"
else
echo  -e "Success! $avail has been removed!\nPlease restart Apache: sudo systemctl restart httpd"
exit 0
fi
fi' >> /usr/local/bin/a2dissite
    chmod +x /usr/local/bin/a2*
    a2ensite default
    sleep 5
    systemctl restart httpd
}

installComposer(){
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
}

installJDK(){
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java8-installer
    sudo apt-get install oracle-java8-set-default
}

installFrameworkPHP(){
    curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
	chmod a+x /usr/local/bin/symfony
	composer global require "laravel/installer=~1.1"
}

installMongodb(){
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org=$MONGODB_VERSION mongodb-org-server=$MONGODB_VERSION mongodb-org-shell=$MONGODB_VERSION mongodb-org-mongos=$MONGODB_VERSION mongodb-org-tools=$MONGODB_VERSION
    sudo touch /etc/php5/mods-available/mongodb.ini
    sudo echo "extension=mongodb.so" >> /etc/php5/mods-available/mongodb.ini
    php5enmod mongodb
    sudo pecl install mongodb
    service apache2 restart
}

installMonodevelop(){
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
    echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
    sudo apt-get update
    sudo apt-get install mono-devel
}

installKomodo(){
    sudo add-apt-repository ppa:mystic-mirage/komodo-edit
    sudo apt-get update
    sudo apt-get install komodo-edit
}

installAudacious(){
    sudo add-apt-repository ppa:nilarimogard/webupd8
    sudo apt-get update
    sudo apt-get install audacious audacious-plugins
}

installGoogleChrome(){
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update 
    sudo apt-get install google-chrome-stable
}

installSublimeText(){
    sudo add-apt-repository ppa:webupd8team/sublime-text-3
    sudo apt-get update
    sudo apt-get sublime-text-installer
}

installPhuml(){
    cd /opt/
    sudo git clone https://github.com/jakobwesthoff/phuml.git
    chmod +x /opt/phuml/src/app/phuml
    cd $OLDPWD
    
    echo '
if [ -f "/opt/phuml/src/app/phuml" ] ; then
    PATH="/opt/phuml/src/app:$PATH"
fi' >> $HOME/.profile
    . $HOME/.profile
}

installDrush(){
    wget http://files.drush.org/drush.phar
    php drush.phar core-status
    chmod +x drush.phar
    sudo mv drush.phar /usr/local/bin/drush
    drush init
}

apache_mime_type(){
	sed -i 's/application\/x-ruby/#application\/x-ruby/g' /etc/mime.types
}


