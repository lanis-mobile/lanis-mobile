# Datenschutzerklärung

## Verantwortlicher
Alessio Caputo

Georg-Jung-Str 38

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
Zur Analyse von Fehlern in der Anwendung wird eine selbst gehostete Instanz des Tools Countly verwendet. So wird jeder anwendungsintere Fehler anonym an die Entwickler gesendet. Dabei können verschiedene Fehler einem Nutzer, dem Nutzer aber keine Person zugeordnet werden.\
Zu den Automatisch erfassten daten Gehören:
- Anwendungsversion
- Betriebssystem-Version
- Smartphone-Modell
- Root-Status des Geräts
- Speicher gesamt/verfügbar
- Speicher gesamt/verfügbar
- Eigentlicher Fehlerbericht

Dies ist für die weitere Entwicklung der App notwendig, da verschiedene Accounts sich in der App sehr unterschiedlich verhalten.

### App-Interner Fehlerbericht

Benutzer haben die Möglichkeit, innerhalb der Anwendung einen Fehlerbericht direkt an die Entwickler zu senden. Ein solcher Fehlerbericht gibt den Entwicklern viel mehr Informationen über das Problem, indem Metadaten, die für die Reproduktion des Problems hilfreich sind, an den Bericht angehängt werden. Ein Bericht besteht aus
 - Schule des Nutzers
 - Login Name des Nutzers
 - Fehlerbeschreibung
 - Kontaktinformation
 - Metadaten (optional)
   - Benutzerdaten
     - Name
     - Geburtsdatum
     - Klasse
     - Geschlecht
   - vollständiger Vertretungsplan der Schule
   - aussagekräftiger Ausschnitt des Schulkalenders (von vor einem Halben Jahr bis in einem Jahr)
   - detaillierte Informationen über die Kurse des Schülers

Die Fehlerbericht-Funktion wird über Cloudflare Workers gehostet. Zugang zu der Datenbank haben nur ausgewählte Entwickler der Anwendung. Daten werden nur nach ausdrücklicher Zustimmung des Nutzers mit dritten geteilt. 

## Verschlüsselung
Jegliche Kommunikation mit den Lanis-Servern, der Countly-Instanz oder dem Bugreport-Server erfolgt ausschließlich mit HTTPS-Verschlüsselung.

Darüber hinaus werden sensible Daten wie Notizen oder Nachrichten durch eine zusätzliche Verschlüsselungsebene geschützt.
