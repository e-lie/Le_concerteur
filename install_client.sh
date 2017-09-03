#!/bin/bash

serverurl=$1
install_dir="/home/pi/concerteur_client"
repo="https://github.com/e-lie/Le_concerteur"


# ==== installer pure data, python etc
sudo apt-get update
sudo apt-get install -y pd puredata-gui python3 python3-pip
sudo pip3 install pydub

mkdir "$install_dir"

# ==== récupérer les sources du client
git clone ${repo} ${install_dir}

# ==== config pure data
sudo cp -f "$install_dir/concerteurConfig/rc.local" /etc/
sudo cp -f "$install_dir/concerteurConfig/.pdsettings" /root/

mv ${install_dir}/concerteurPureData /home/pi
mv ${install_dir}/concerteurClient /home/pi
touch /home/pi/pd_concerteur.log
touch /home/pi/polling_concerteur.log

# ==== install ffmpeg
sudo cp "$install_dir/ffmpeg/ffmpeg" /usr/local/bin/
sudo ln -s /usr/bin/ffmpeg /usr/bin/ffmpeg
sudo cp -Rf ${install_dir}/ffmpeg/lib/* /usr/lib/arm-linux-gnueabihf/

sudo pip3 install pydub

# ==== config python script
sed -i "s@SERVERURL@$serverurl@g" /home/pi/concerteurClient/polling.py

# ==== ajouter le cron
croncmd="sudo -u pi /usr/bin/python3 /home/pi/concerteurClient/polling.py >> /home/pi/polling_concerteur.log 2>&1"
cronjob="* * * * * $croncmd"

# ajouter au cron root
# (1- lister le contenu du cron
# 2- enlever la ligne contenant la commande si existe déjà,
# 3- ajouter le cronjob, 4- passer ce contenu à la crontab)
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

# command to remove the cronjob ( crontab -l | grep -v -F "$croncmd" ) | crontab -

rm -Rf ${install_dir}
sudo reboot


