import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../client/client.dart';


/*
* todo @kurwjan Build setup screens
* Vertretungsplan:
*  - Filter
*   - Wie Funktioniert er?
*   - Einrichten
*  - Benachrichtigungen
*   - An/Aus
*   - Zeitintervall
*  (evtl einfach die normalen einstellungen als Widget laden anstatt zu kopieren?)
* Kalender:
*  - Da muss nichts gemacht werden, oder?
* Nachrichten:
*  - glaube auch nicht
* Mein Unterricht:
*  - eigentlich auch nicht
* Lademodus:
*  - selbsterklärend
* */

List<PageViewModel> setupScreenPageViewModels = [
  if (client.doesSupportFeature("Vertretungsplan")) PageViewModel(
    titleWidget: const Text("Vertretungsplan"),
    bodyWidget: Center(
        child: ElevatedButton(
          child: const Text("Sachen eben"),
          onPressed: (){},
        )
    )
  ),
  PageViewModel(
      image: SvgPicture.asset("assets/undraw/undraw_access_account_re_8spm.svg", height: 175.0),
      title: "Du bist jetźt bereit!",
      body: "Du kannst lanis Mobile jetzt verwenden. Wenn die die App gefällt, kannst du gerne eine Bewertung im Play Store machen."
  ),
];