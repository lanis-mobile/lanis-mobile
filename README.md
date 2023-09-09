# SPH-Vertretungsplan

<i>Work in progress</i>

Diese App soll 2 probleme Lösen:

- den Vertrtungsplan schnell abrufen
    - login dauert lange
- den Filter für den eigenen Plan verbessern, weil der normale Schrott ist. 

## Alles auf einem gerät?
Ursprünglich war der Plan mein npm Packet <a href="https://www.npmjs.com/package/sphclient">SPHclient</a> auf der Client seite zu verwenden, um ein Serverloses abrufen zur ermöglichen. <br> Es stellt sich heraus, dass CORS das nicht zulässt. <a href="https://ionicframework.com/docs/troubleshooting/cors">siehe hier</a>

## Server also?
Ja, aber der Server ist so konzipiert, dass ihn jeder nutzen kann. Er soll keine Benutzerdaten speichern, sondern eher eine Proxy-Funktion erfüllen.