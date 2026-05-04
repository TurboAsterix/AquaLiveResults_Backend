# AquaLiveResults_Backend
AquaLiveResults: Live race results from Aquarius, backend component

# Demo und Dokumentation
https://www.aqualiveresults.de/

# Was ist AquaLiveResults?
AquaLiveResults ermöglicht die (nahezu) Echtzeit-Anzeige von Regatta-Ergebnissen aus der im Rudersport weit verbreiteten Software Aquarius. 
Die Ergebnisse werden auf einer Webseite dargestellt, sodass Athleten, Publikum und Veranstalter sie direkt nach dem Zieleinlauf abrufen können ohne auf den Aushang der Ergebnisse zu warten.

# Backend
Bei diesem Repository handelt es sich um die Backend-Komponente, die auf einem Aquarius Rechner im LAN installiert und ausgeführt wird. 

## Systemvorbereitung
- Powershell installieren, siehe https://github.com/PowerShell/PowerShell/releases
- Datei PowerShell-7.x.x-win-x64.msi für Windows 10/11 Systeme
- PuTTY installieren, siehe https://putty.org
- PuTTY wird benötigt für pscp.exe für den SFTP Transfer

## Installation
- Repository in einen Ordner klonen

## Konfiguration 
Die Datei ./interface.ini anpassen mit:
- dem Pfad zur Aquarius.ini im Windows Benutzerprofil
- dem Aquarius Datenbank Passwort des DB Benutzers "SA" der Datenbank "Rudern"
- SFTP Server, Benutzername, Passwort und Remote Pfad

## Veranstaltung auswählen
- Für den DB Select benötigen wir die interne Event ID. Hierzu Aquarius öffnen, die Veranstaltung auswählen/öffnen und -wichtig- Aquarius wieder schließen.
- Aquarius schreibt die Event ID leider erst beim Schließen des Programms in die Aquarius.ini
- Anschließend kann Aquarius auf dem Rechner wieder geöffnet/verwendet werden.

## Ausführung im Powershell Terminal
- ./interface_start.ps1 startet die Schnittstelle; in der Standardeinstellung Ausleitung aus Aquarius und SFTP Transfer alle 3 Minuten
<img width="1112" height="624" alt="aqualiveresults_backend2" src="https://github.com/user-attachments/assets/3f351e03-16c0-4ebe-b3a6-651d955fadc2" />
- ./interface_start_reset.ps1 startet die Schnittstelle einmalig um die Daten auf dem Webserver zu löschen und durch Dummy-Daten zu ersetzen (aufräumen)

# Daten
Die Backend-Komponente extrahiert die Rennergebnisse und aktualisiert (im Standard alle 3 Minuten) die Datei ./public/data/aquarius_db_output.json per SFTP.
Siehe ./interface_start.ps1

# Frontend
Eine Webanwendung, die speziell für die Darstellung großer, responsiver und dynamisch geladener Tabellen optimiert ist und auf Smartphones, Tablets und Desktops funktioniert. 
Die Tabellenzeilen können expandiert werden um Titel, Lauf, Abteilung, Bahn und Namen der Mannschaft anzuzeigen.
Siehe hier: https://github.com/TurboAsterix/AquaLiveResults_Frontend
  
# Interface.ini
Enthält Code von https://stackoverflow.com/a/43697842/1031534 und https://gist.github.com/beruic/1be71ae570646bca40734280ea357e3c zum Auslesen der .ini
Lizenz wie dort angegeben.

# Erster Transfer
Ggf. ist beim ersten Transfer der Server Fingerprint in PuTTY noch nicht bekannt. Dann im ersten Durchlauf die Abfrage mit Yes bestätigen (sofern man sicher den korrekten Server konfiguriert hat). 
Die Abfrage wird nur beim ersten Transfer von diesem Client zu diesem Server anzeigt. 
<img width="1115" height="872" alt="aqualiveresults_backend_fingerprint" src="https://github.com/user-attachments/assets/bb54e50d-4492-49d9-90d1-e712ca567d75" />
