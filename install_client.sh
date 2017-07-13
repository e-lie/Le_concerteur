#!/bin/bash

serverurl="https://pharmakonpc.fr"

install_dir="/home/pi/concerteur_client"


# ==== installer pure data, python etc
sudo apt-get update
sudo apt-get install -y pd vim python3 python3-pip
sudo pip3 install pydub

mkdir "$install_dir"

# ==== récupérer les sources du client
git clone https://github.com/e-lie/Le_concerteur "$install_dir"

# ==== config pure data
sudo cp "$install_dir/concerteurConfig/rc.local" "/etc/"
cp "$install_dir/concerteurConfig/.pdsettings" /home/pi

# ==== install ffmpeg
sudo cp "$install_dir/ffmpeg/ffmpeg" /usr/local/bin/
sudo ln -s /usr/bin/ffmpeg /usr/bin/ffmpeg
sudo cp -Rf ${install_dir}/ffmpeg/lib/* /usr/lib/arm-linux-gnueabihf/

sudo pip3 install pydub

# ==== config python script
sudo sed -i "s@SERVERURL@$serverurl@g" ${install_dir}/concerteurClient/polling.py

# ==== ajouter le cron
croncmd="/usr/bin/python3 /home/pi/concerteurClient/polling.py &> /home/pi/concerteurClient/sounds/cronlog"
cronjob="* * * * * $croncmd"

# ajouter au cron root
# (1- lister le contenu du cron
# 2- enlever la ligne contenant la commande si existe déjà,
# 3- ajouter le cronjob, 4- passer ce contenu à la crontab)
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

# command to remove the cronjob ( crontab -l | grep -v -F "$croncmd" ) | crontab -



