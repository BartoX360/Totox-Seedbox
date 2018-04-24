#!/bin/bash
if [ "$UID" -ne "0" ]
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
echo "-------------------------"
echo "| Installation de Nginx |"
echo "-------------------------"


echo "----------------------------"
echo "| Installation de rTorrent |"
echo "----------------------------"
apt-get update && apt-get upgrade -y
