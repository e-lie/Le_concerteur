
# Le concerteur client


L'objet des instructions et des scripts qui vont suivre est au maximum d'automatiser l'installation d'un serveur et
d'un client raspberry Pi pour le projet "le concerteur". Cependant, il n'est pas garanti qu'ils soient exhaustifs et une certaine
dose de compréhension du projet est nécessaire pour pouvoir faire sens de ces instructions.

## Installation du serveur

* avoir un serveur et un nom de domaine
* installer debian stable dessus
* installer yunohost : https://yunohost.org/#/install_manually_fr


## Installation du client

### matériel
* un raspi 2 ou 3
* la carte sd avec un lecteur

### installer raspbian

* télécharger raspbian complet (avec interface) : https://www.raspberrypi.org/downloads/raspbian/
* flasher la carte SD : https://www.raspberrypi.org/documentation/installation/installing-images/

2 possibilités : configurer le raspi avec un écran ou sans écran (ssh)

### installation graphique

connecter l'écran + clavier + souris
démarrer le raspi
lorsque la session est lancée, ouvrir un terminal puis passer à l'installation du client proprement dite


### installation ssh

* ajouter un fichier vide nommé `ssh` dans la partition boot de la carte SD flashée (pour pouvoir s'y connecter en ssh sans écran)
* brancher le raspi avec la carte dedans et connecté en ethernet(RJ45) à votre box/routeur ou lancer le raspi connecté à un écran
* ouvrir un terminal sur votre ordinateur mac/linux
* pour trouver la 


installer pd vim
