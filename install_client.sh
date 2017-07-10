#!/bin/bash

serverurl="https://pharmakonpc.fr"


# ==== installer pure data, python etc
sudo apt-get update
sudo apt-get install -y pd vim python3 python-virtualenv python3-pip

# ==== récupérer les sources du client
git clone https://github.com/e-lie/concerteur_client /home/pi

# ==== config pure data
sudo cp /home/pi/concerteurConfig/rc.local /etc/
cp /home/pi/concerteurConfig/.pdsettings /home/pi/

# ==== install ffmpeg
cp /home/pi/ffmpeg/ffmpeg /usr/local/bin/
ln -s /usr/bin/ffmpeg /usr/bin/ffmpeg
cp -Rf /home/pi/ffmpeg/lib/* /usr/lib/arm-linux-gnueabihf/

# ===== python part
virtualenv -p python3 /home/pi/concerteurClient/venv
source /home/pi/concerteurClient/.env
pip3 install -r /home/pi/concerteurClient/requirements.txt

# ==== config python script
sudo sed -i "s@SERVERURL@$serverurl@g" /home/pi/concerteurClient/polling.py

# ==== ajouter le cron
croncmd="/usr/bin/python3 /home/pi/concerteurClient/polling.py &> /home/pi/concerteurClient/sounds/cronlog"
cronjob="* * * * * $croncmd"

# ajouter au cron root
# (1- lister le contenu du cron
# 2- enlever la ligne contenant la commande si existe déjà,
# 3- ajouter le cronjob, 4- passer ce contenu à la crontab)
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

# command to remove the cronjob ( crontab -l | grep -v -F "$croncmd" ) | crontab -



