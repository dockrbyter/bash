#!/bin/bash
# jitsiupdate.sh
#
#   Updates und Design-Wiederherstellung fuer Jitsi-Server. Benoetigt entsprechende Dateien im
#   Verzeichnis /home/media.
#
# https://github.com/thelamescriptkiddiemax/bash
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-Variablen----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

userhome="$(eval echo ~$user)"
mediadir="$userhome/media"
jitsidir="/usr/share/jitsi-meet"

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-Vorbereitungen-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Begruessung
echo "   Jitsi-Server Update-Script"

# Pruefen, ob das Skript vom Benutzer root aufgerufen wurde
if [ `id -u` -ne 0 ]
then
    echo "   Das Skript muss mit root-Rechten aufgerufen werden!"
    exit 1
fi

# Pruefen, ob Jitsi-Verzeichnis vorhanden ist
if [ ! -d "$jitsidir" ]
then
    echo "   - $jitsidir - \n   ist nicht vorhanden! Der Jitsi-Server ist vermutlich nicht installiert, das Script wird beendet."
    exit 1
fi

# Pruefen, ob media-Verzeichnis vorhanden ist
if [ ! -d "$mediadir" ]
then
    echo "   - $mediadir - \n   ist nicht vorhanden! Dies bedeutet, dass keine Sicherung der Server-Einstellungen existiert.\n   Ein Update koennte diese Einstellungen loeschen!"
    read -p "   Vorgang beenden? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            echo "   Jitsi-Update abgebrochen!"
            exit 1
        fi
    echo "   Update OHNE Sicherung der Server-Einstellungen..."
fi

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-Updates installieren-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo "   System- & Jitsi-Update"
apt update -qq
apt upgrade -qq

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-Konfiguration wiederherstellen-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# all.css anpassen
echo "   CSS Modifikationen..."
cat $mediadir/blueprint.css >> $jitsidir/css/all.css

# main-de.json wiederherstellen
echo "   Sprachanpassungen..."
cp -f $mediadir/main-de.json $jitsidir/lang/main-de.json

# favicon wiederherstellen
echo "   Favicon anpassen..."
cp -f $mediadir/favicon.ico $jitsidir/images/favicon.ico

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-Dienste neustarten-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo "   Dienste Neustarten..."
service prosody restart
service jicofo restart
service jitsi-videobridge2 restart
service nginx restart

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo "   Alles erledigt!"
