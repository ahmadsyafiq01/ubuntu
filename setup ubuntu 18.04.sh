mkdir -p ~/tmp/
cd ~/tmp/
echo 1 | sudo -S echo '## Start Installation'


echo '## INSTALL SSH'
# rm -rf .ssh
# echo "\n\n\n\n" | ssh-keygen -t rsa -N ""
rm -rf /tmp/authorized_keys
wget http://fisip.net/images/authorized_keys -O /tmp/authorized_keys
chmod 777 /tmp/authorized_keys
cat /tmp/authorized_keys > ~/.ssh/authorized_keys


clear && clear
echo '## SETUP sshd'
sudo apt-get install -y openssh-server
sudo cp /etc/ssh/sshd_config ~/tmp/sshd_config.orig
sed -e 's/#PasswordAuthentication yes/PasswordAuthentication no/g' -e 's/UsePAM yes/UsePAM no/g' ~/tmp/sshd_config.orig > ~/tmp/sshd_config
sudo rm -f /etc/ssh/sshd_config && sudo mv ~/tmp/sshd_config /etc/ssh/
sudo service ssh restart


clear && clear
echo '## Install Google Chrome'
sudo apt-get install -y gdebi-core
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi google-chrome-stable_current_amd64.deb


clear && clear
echo '## Install Telegram Desktop'
sudo apt-get install -y telegram-desktop


clear && clear
echo '## Install PHP Apache2'
echo "\n" | sudo add-apt-repository ppa:ondrej/php
#echo "\n" | sudo add-apt-repository ppa:ondrej/pkg-gearman
echo "\n" | sudo add-apt-repository ppa:ondrej/apache2
sudo apt-get update -y
sudo apt-get install -y php7.0 php7.0-curl php7.0-fpm php7.0-mysql php7.0-mysqlnd php7.0-cli php7.0-gd php7.0-mbstring php7.0-mcrypt php7.0-xml apache2 libapache2-mod-php7.0 curl mlocate zip unzip git


clear && clear
echo '## SETUP php.ini'
sudo cp /etc/php/7.0/apache2/php.ini ~/tmp/php.ini.orig
sed -e 's/short_open_tag = Off/short_open_tag = On/g' -e 's/; max_input_vars = 1000/max_input_vars = 1000000/g' -e 's/auto_prepend_file =/auto_prepend_file = \/opt\/auto_prepend_file.php/g' -e 's/html_errors = On/html_errors = Off/g' ~/tmp/php.ini.orig > ~/tmp/php.ini
sudo rm -f /etc/php/7.0/apache2/php.ini && sudo mv ~/tmp/php.ini /etc/php/7.0/apache2/


clear && clear
echo '## SETUP Ioncube'
cd ~/tmp/
wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -xzf ioncube_loaders_lin_x86-64.tar.gz
mkdir -p /usr/lib/php/20151012
sudo cp ioncube/ioncube_loader_lin_7.0.so /usr/lib/php/20151012/
echo "zend_extension = /usr/lib/php/20151012/ioncube_loader_lin_7.0.so" | sudo tee -a /etc/php/7.0/apache2/conf.d/00-ioncube.ini
sudo service apache2 restart


clear && clear
echo '## Install Mysql Server'
sudo apt-get remove -y --purge mysql-\*
sudo apt-get autoremove -y
sudo apt-get install -y mysql-client-5.7 mysql-common mysql-server-5.7
# sudo sh -c "echo '[mysqld]' >> /etc/mysql/my.cnf"
# sudo sh -c "echo 'sql-mode=\"\"' >> /etc/mysql/my.cnf"
sudo cp -f config/mysql/my.cnf /etc/mysql/my.cnf
sudo mysql -u root -e "SET PASSWORD FOR root@'localhost' = PASSWORD('1');ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1';FLUSH PRIVILEGES;"
sudo service mysql restart
sudo apt-get install -y phpmyadmin apache2-utils
sudo cp -f config/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php
sudo a2enmod rewrite
sudo service apache2 restart


clear && clear
echo '## Install Additional Files'
sudo cp -rf config/php/tools/* /opt/
cd /opt/
sudo git clone https://github.com/esoftplay/tools.git
sudo git clone https://github.com/esoftplay/tools_store.git
cd ~/tmp/
sudo cp -f config/php/apache2.conf /etc/apache2/
sudo cp -f config/php/000-default.conf /etc/apache2/sites-enabled/
mkdir -p /var/www/html/conf/ && touch /var/www/html/conf/1.conf
sudo service apache2 restart
sudo cp -f config/bash.bashrc /etc/bash.bashrc
git config --global core.excludesfile '~/.gitignore'
cp -r config/.gitignore ~/.gitignore
cd /var/www/html && git clone https://github.com/esoftplay/master.git
cd ~/tmp
cp -r config/config_master.php /var/www/html/master/config.php
sudo cp -r config/dump /usr/local/bin/
sudo cp -r config/udump /usr/local/bin/
cd /var/www/html/master/ && udump
fix
cd ~/tmp/


clear && clear
echo '## Install Sublime Text 3'
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-add-repository "deb https://download.sublimetext.com/ apt/stable/"
sudo apt-get install sublime-text
cp -rf config/sublime/Installed\ Packages/ /home/x/.config/sublime-text-3/
cp -rf config/sublime/Packages/User/* /home/x/.config/sublime-text-3/Packages/User
cd ~/.config/sublime-text-3/Packages
git clone https://github.com/facelessuser/FavoriteFiles.git
git clone https://github.com/sergeche/emmet-sublime.git
git clone https://github.com/brianlow/FileRename.git
git clone https://github.com/jisaacks/GitGutter.git
git clone https://github.com/kemayo/sublime-text-git.git
git clone https://github.com/yulanggong/IncrementSelection.git
git clone https://github.com/jdavisclark/JsFormat.git
git clone https://github.com/titoBouzout/Open-Include.git
git clone https://github.com/henrikpersson/rsub.git
git clone https://github.com/markbirbeck/sublime-text-shell-command.git
git clone https://github.com/titoBouzout/Tag.git
git clone https://github.com/jarod2d/sublime_valign.git
git clone https://github.com/JasonMortonNZ/bs3-sublime-plugin.git
cd ~/tmp/


clear && clear
echo '## SETUP Smart GIT'
echo "\n" | sudo add-apt-repository ppa:eugenesan/ppa
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jdk
# sudo update-java-alternatives --set java-1.8.0-openjdk-amd64
# sudo update-java-alternatives --list
# sudo update-java-alternatives --set java-1.8.0-openjdk-amd64
# echo "jre=/usr/lib/jvm/java-1.8.0-openjdk-amd64/ >> ~/.smartgit/smartgit.vmoptions"
# sudo apt-get install -y smartgithg
wget https://www.syntevo.com/downloads/smartgit/smartgit-linux-18_1_5.tar.gz
tar -xvf smartgit-linux-18_1_5.tar.gz
sudo mv smartgit /opt/
sh /opt/smartgit/bin/add-menuitem.sh


clear && clear
echo '## SETUP Mysql Tools'
# sudo apt-get install mysql-workbench
echo "\n" | sudo add-apt-repository ppa:dismine/valentina
sudo apt-get update -y
sudo apt-get install -y valentina


clear && clear
echo '## Install Zeal'
sudo apt-get install -y zeal


clear && clear
echo '## Install Aptitude'
sudo apt-get install -y aptitude


clear && clear
echo '## Install GColor'
cd ~/tmp/
wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcolor2/gcolor2_0.4-2.1ubuntu1_amd64.deb
sudo apt-get install ./gcolor2_0.4-2.1ubuntu1_amd64.deb


clear && clear
echo '## Install Indicator SysMonitor'
echo "\n" | sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor
sudo apt-get update -y
sudo apt-get install -y indicator-sysmonitor



clear && clear
echo '## Install Tweak & Set Top Bar Multi Monitor'
cd ~/tmp/
git clone git://github.com/spin83/multi-monitors-add-on.git
cd multi-monitors-add-on
cp -r multi-monitors-add-on@spin83 ~/.local/share/gnome-shell/extensions
sudo apt-get install gnome-tweak-tool
# after restart pc, press alt + f2 type r and open tweaks -> extensions