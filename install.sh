#!/bin/bash
dirStart=$(pwd) # On récupère le dossier ou on est actuellement pour l'installation plus tard
echo "Entrez le dossier ou sera installé la seedbox (Exemple /srv/seedbox): "
read dirSeedbox
if [ "$UID" -ne "0" ] # On vérifie que l'utilisateur est bien root
then
   echo "Le script doit être lancé en Root, installation abandonnée"
   exit 1
fi
echo "-----------------------------------------------------------------------------------------------------------------------------------------"
echo "| Script d'installation de Seedbox par Bartox                                                                                           |"
echo "| Ce Script va installer rTorrent avec l'interface Flood ainsi qu'un serveur Nginx                                                      |"
echo "| Script testé sur Debian 9. Le lancer sur une machine propre est fortement recommandé.                                                 |"
echo "| Je vous recommande de lancer le script dans un screen, l'installation étant assez longue on est jamais à l'abri d'une coupure réseau. |"
echo "-----------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------"
echo "| Installation de rTorrent |"
echo "----------------------------"
echo "Mise à jour des paquets" # Je met à jour les paquets et fais un uprade au cas ou. A voir pour peut-être enlever l'upgrade.
apt-get update
echo "Installation des dépendances de rTorrent et rTorrent"
apt install rtorrent sudo screen build-essential subversion autoconf g++ gcc curl comerr-dev pkg-config cfv libtool libssl-dev libncurses5-dev ncurses-term libsigc++-2.0-dev libcppunit-dev libcurl3 libcurl4-openssl-dev -y
echo "Création de l'utilisateur rtorrent"
adduser --disabled-password rtorrent
echo "Copie du fichier de configuration de rTorrent"
cp $dirStart/rtorrent.rc /home/rtorrent/.rtorrent.rc
echo "Création des dossiers avec les différentes permissions"
mkdir -p $dirSeedbox/{downloads,.session}
chmod 775 -R $dirSeedbox
chown rtorrent:rtorrent -R $dirSeedbox
chown rtorrent:rtorrent /home/rtorrent/.rtorrent.rc
echo "Création du script pour Systemd"
cp $dirStart/rtorrent.service /etc/systemd/system/rtorrent.service
echo "Activation du service rTorrent et démarrage au boot du serveur"
systemctl daemon-reload
systemctl enable rtorrent.service
systemctl start rtorrent.service
echo "-------------------------"
echo "| Installation de flood |"
echo "-------------------------"
echo "Installation de nodeJS"
curl -sL https://deb.nodesource.com/setup_9.x | bash -
apt-get install -y nodejs
echo "Récupération de la dernière version de flood sur Git"
cd $dirSeedbox
git clone https://github.com/jfurrow/flood.git
echo "On installe le fichier de configuration de flood"
cd $dirSeedbox/flood
cp config.template.js config.js
echo "Création de l'utilisateur Flood"
adduser --disabled-password flood
chown -R flood:flood $dirSeedbox/flood/
echo "Création du script pour Systemd"
cp $dirStart/flood.service /etc/systemd/system/flood.service
echo "Activation du service rTorrent et démarrage au boot du serveur"
systemctl daemon-reload
systemctl enable flood.service
systemctl start flood.service
echo "-------------------------"
echo "| Installation de Nginx |"
echo "-------------------------"

echo "-------------------------"
echo "| Installation terminée |"
echo "-------------------------"
echo "Les fichiers téléchargé par rTorrent sont placés dans $dirSeedbox/downloads"
echo "On peut vérifier que rTorrent est bien lancé avec un ps -aux | grep rtorrent"
echo "Pour arrêter rTorrent : systemctl stop rtorrent"
echo "Pour lancer rTorrent : systemctl start rtorrent"
echo "Pour redémarrer rTorrent : systemctl restart rtorrent"
