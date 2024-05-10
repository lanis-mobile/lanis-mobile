# Datenschutzerklärung

## Verantwortlicher
Alessio Caputo

65428 Rüsselsheim am Main

E-Mail: alessioc42.dev@gmail.com


## Das Schulportal Hessen
Diese Anwendung steht in keiner Verbindung zu den Entwicklern des Schulportals Hessen.
Da diese Anwendung im wensentlichen Funktionen des Schulportals "kopiert", ist auf dessen Datenschutzerklärung zu verweisen:

https://info.schulportal.hessen.de/datenschutzerklaerung/

## Erhobene Daten
Die Anwendung lanis-mobile erfasst folgende personenbezogene Daten:
- Schule (oder Schulnummer)
- Benutzername
- Passwort

Diese Daten sind für die Funktion der App notwendig, werden lokal gespeichert und zum Login an die Server des Schulportals Hessen übertragen. Die Schulnummer wird ggf. anonymisiert zur Fehleranalyse an die Entwickler gesendet.
## Zugriffsreche
### Netzwerkzugang
Die Anwendung benötigt einen Netzzugang, um mit den Servern des Schulportals Hessen kommunizieren zu können.
### Benachrichtigungen
Die Benachrichtigungsberechtigungen werden für die Benachrichtigungen des Vertretungsplans benötigt. Ohne diese Berechtigung können keine Benachrichtigungen versendet werden. Die Anwendung kann jedoch auch ohne dieses Feature verwendet werden.
### Geräteinformationen
Allgemeine Geräteinformationen werden als Teil von automatischen Fehlerberichten gesendet. Diese Geräteinformationen umfassen
Die Erfassung dieser Daten ist für die Analyse, Reproduktion und Fehlerbehebung notwendig. (siehe [Fehleranalyse>Countly](#countly))
## Lokal gespeicherte Daten
Die Anwendung muss um den Nutzer beim App-Start anzumelden bestimmte Daten Lokal speichern. Diese umfassen in erster Linie Schulnummer, Loginname und das Passwort des Benutzers. Das Passwort wird in einer durch den Android-Keystore gesicherten Umgebung gespeichert. Die weiteren gespeicherten Daten werden Unverschlüsselt gespeichert.

Des weiteren werden Nutzereinstellungen ebenfalls Lokal unverschlüsselt gespeichert.
## Fehleranalyse
### Countly
Zur Analyse von Fehlern in der Anwendung wird eine selbst gehostete Instanz des Tools Countly verwendet. So wird jeder anwendungsintere Fehler anonym an die Entwickler gesendet. Dabei können verschiedene Fehler einem Nutzer, dem Nutzer aber keine Person zugeordnet werden. Diese daten werden nur erfasst, wenn der Nutzer dieses Feature aktiviert. Er kann dies beim Login und auch später in den Einstellungen festlegen. \
Zu den Automatisch erfassten daten Gehören:
- Anwendungsversion
- Ungefährer Standort (aktuelle Stadt basierend auf der IP Adresse des Senders)
- Nutzungsdauer der App
- Betriebssystem-Version
- Smartphone-Modell
- Root-Status des Geräts
- Speicher gesamt/verfügbar
- Speicher gesamt/verfügbar
- Eigentlicher Fehlerbericht

Dies ist für die weitere Entwicklung der App notwendig, da verschiedene Accounts sich in der App sehr unterschiedlich verhalten. Das Analysetool erleichtert die Anpassung 

## Verschlüsselung
Jegliche Kommunikation mit den Lanis-Servern, der Countly-Instanz oder dem Bugreport-Server erfolgt ausschließlich mit HTTPS-Verschlüsselung.

Darüber hinaus werden sensible Daten wie Notizen oder Nachrichten durch eine zusätzliche Verschlüsselungsebene geschützt, die von der API des Schulportals vorgegeben wird.
