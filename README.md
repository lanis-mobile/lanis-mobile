# Lanis Mobile
Inoffizielle App rund um das Schulportal Hessen.

**Einsatz an über 200 Schulen in Hessen mit Tausenden Nutzern**

<p align="center">
    <img src="https://github.com/alessioC42/lanis-mobile/assets/84250128/19d30436-32f7-4cbe-b78e-f2fee3583c28" width="60%">
</p>
<a href='https://play.google.com/store/apps/details?id=io.github.alessioc42.sph&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'>
  <img alt='Jetzt bei Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/de_badge_web_generic.png' style='height: 71px'/>
</a>

<a href="https://apt.izzysoft.de/fdroid/index/apk/io.github.alessioc42.sph"><img src="https://www.martinstoeckli.ch/images/izzy-on-droid-badge-en.png" alt="Get it on IzzyOnDroid" style="height: 56px;"></a>

<a href='https://apps.apple.com/de/app/lanis-mobile/id6511247743?l=en-GB'>
  <img alt='Jetzt im App Store' src='https://lanis-mobile.github.io/assets/ios-badge.svg' style='height: 61px'/>
</a>

<p></p>
<details>
  <summary>Screenshots</summary>
<div style="text-align: center;">
  <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/01.png" width="250" >
  <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/02.png" width="250" >
  <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/03.png" width="250" >
  <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/04.png" width="250" >
  <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/05.png" width="250" >
  <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/06.png" width="250" >
  <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/07.png" width="250" >

</div>
</details>

## Hilf mit!
Wir sind offen für neue Collaborator. Aber auch wenn du nicht coden kannst, bist du in der Lage einen Beitrag zur App zu leisten. Du kannst den Vertretungsplan deiner Schule anpassen. Siehe [hier](https://github.com/alessioC42/lanis-mobile-autoconfig/issues/1) und [hier](https://github.com/alessioC42/lanis-mobile-autoconfig)

## features
- [x] Login
- [x] Vertretungsplan
- [x] Vertretungsplan Push benachrichtigungen (Android)
- [x] Schulkalender
- [x] Lanis eingeloggt im browser öffnen
- [x] Benutzerdaten
- [x] Mein Unterricht
- [x] Nachrichten
- [x] Datenspeicher
- [x] Stundenplan
- [x] Offline views

## Mitarbeit
[Schulkonfiguration der Vertretungspläne](https://github.com/alessioC42/lanis-mobile-autoconfig)

Dieses Projekt ist stark von Bug-Reports anderer Schulen oder von neuen Mitarbeitern abhängig. Der Grund dafür liegt in
der modularen Natur des Schulportals, die es äußerst schwierig macht, eine universelle Lanis-App zu entwickeln.

Scheue dich nicht, einen Bug-Report zu erstellen, wenn du einen Fehler findest. Wir sind immer offen für neue Mitarbeiter/Schüler, die mit uns arbeiten, um die App zu verbessern.

Bug-Reports können auch an <a href="mailto:alessioc42.dev@gmail.com">diese</a> E-Mail-Adresse gesendet werden, falls kein Github-Konto vorhanden ist.

## How to build (Linux)
1. Setup Flutter in Android Studio
2. Install JDK 17 with your package manager
3. 
    ```shell
    # Configure flutter to use JDK 17 and not the Android Studio JDK, otherwise the Project won't compile
    flutter config --jdk-dir=/usr/lib/jvm/java-17-openjdk # The path may differ based on your distro

    # Generate the code
    dart run build_runner build

    # Build
    flutter build YOUR_PLATFORM # Release doesn't work for adb or apk because of some signing stuff
    ```