#!/bin/bash


# installer pure data
apt-get install -Y pd vim

git clone https://github.com/e-lie/concerteur_client /home/pi

cp /home/pi/concerteurConfig/rc.local /etc/
cp /home/pi/concerteurConfig/.pdsettings /home/pi/

croncmd="/usr/bin/python3 /home/pi/concerteurClient/polling.py &> /home/pi/concerteurClient/sounds/cronlog"
cronjob="* * * * * $croncmd"

#ajouter au cron root
# (lister le contenu du cron)
# enlever la ligne contenant la commande si existe déjà,
# ajouter le cronjob, passer ce contenu à la crontab)
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

# command to remove the cronjob ( crontab -l | grep -v -F "$croncmd" ) | crontab -





git clone