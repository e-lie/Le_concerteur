
# Le concerteur


L'objet des instructions et des scripts qui vont suivre est au maximum d'automatiser l'installation d'un serveur et
d'un client raspberry Pi pour le projet "le concerteur". Cependant, il n'est pas garanti qu'ils soient exhaustifs et une certaine
dose de compréhension du projet est nécessaire pour pouvoir faire sens de ces instructions.

## clarifier quelques informations

 * choisir un nom de domaine : exp leconcerteur.fr
 * choisir un nom d'utilisateur
 * définir un mot de passe et mettre le même partout

## Installation du serveur

* avoir un serveur et un nom de domaine
   * commander un VPS avec Debian Jessie ou installer Debian sur un ordinateur connecté à votre box/routeur
   * aller par exemple acheter un nom de domaine ovh.com ou autre
   * une fois le domaine acheté, allez dans l'interface d'administration > zone DNS et faire pointer votre domaine sur le serveur
      * ajouter un champ de type A: votre domaine -> ip de votre serveur (à récupérer dans l'interface d'admin du VPS)
      * ajouter un champ de type MX10 cf : 
* installer debian stable dessus
* installer yunohost : https://yunohost.org/#/install_manually_fr
* faire la post installation : ```yunohost tools postinstall```
   * entrer le nom de domaine
   * définir un mdp pour l'administrateur Yunohost
* ajouter un utilisateur :
   * visitez l'adresse ```nomdedomaine.fr/yunohost/admin```
   * allez dans `Utilisateurs` et cliquer sur  `+ Nouvel Utilisateur`
* installer l'application concerteur en ssh : `yunohost app install https://github.com/e-lie/concerteur_ynh`
   * choisir un emplacement (par défaut `/concerteur`)
   * choisir votre nom de domaine
   * choisir un utilisateur 
* visitez


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
* trouvez l'adresse IP locale du raspberry pi (par exemple avec nmap ou arp-scan)
* se connecter en ssh : `ssh pi@<adresse ip>`
* mdp `raspberry`

### installation automatique du client

* dans le terminal
* télécharger le script d'installation : `wget https://raw.githubusercontent.com/e-lie/Le_concerteur/master/install_client.sh`
* le rendre executable : `chmod +x install_client.sh`
* lancer le script avec en argument l'adresse du serveur (par exemple https://concerteur.net/concerteur) : `./install_client.sh <adresse https du serveur>`
* à la fin de l'installation le raspi reboote et devrait émettre une note longue à la fin du démarrage
* la synchronisation devrait être automatique !
