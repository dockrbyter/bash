#!/bin/bash

# jitsiupdate.sh
#
#   Updates und Design-Wiederherstellung fuer Jitsi-Server. Benoetigt entsprechende Dateien im
#   Verzeichnis /home/media.
#
# https://github.com/thelamescriptkiddiemax/bash
#----------------------------------------------------------------------------------------------------

userhome=$(eval echo ~$user)

#----------------------------------------------------------------------------------------------------

# Begruessung
echo "   Jitsi-Server Update-Script"

# Updates
echo "   System- & Jitsi-Update"
apt update -qq
apt upgrade -qq -y

# all.css anpassen
echo "   CSS Modifikationen..."
cat c/media/blueprint.css >> /usr/share/jitsi-meet/css/all.css

# main-de.json wiederherstellen
echo "   Sprachanpassungen..."
cp -f $userhome/media/main-de.json /usr/share/jitsi-meet/lang/main-de.json

# favicon wiederherstellen
echo "   Favicon anpassen..."
cp -f $userhome/media/favicon.ico /usr/share/jitsi-meet/images/favicon.ico

# Dienste neustarten
echo "   Dienste Neustarten..."
service prosody restart
service jicofo restart
service jitsi-videobridge2 restart
service nginx restart

echo "Alles erledigt!"
