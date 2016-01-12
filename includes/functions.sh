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
}

installPKG(){
	if [ "$PKGSTOINSTALL" != "" ]; then
		echo -n "Some dependencies are missing. Want to install them? (Y/n): "
		read SURE
		if [[ $SURE = "Y" || $SURE = "y" ]]; then
            if which apt-get &> /dev/null; then
				apt-get install -y $PKGSTOINSTALL
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
            fi
        fi
    fi
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

apache_mime_type(){
	sed -i 's/application\/x-ruby/#application\/x-ruby/g' /etc/mime.types
}


