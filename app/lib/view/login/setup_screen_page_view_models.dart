import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sph_plan/view/vertretungsplan/substitutionWidget.dart';

import '../../client/client.dart';
import '../vertretungsplan/filtersettings.dart';


/*
* todo @kurwjan Build setup screens
* Vertretungsplan:
*  - Filter ✓
*   - Wie Funktioniert er? ✓
*   - Einrichten ✓
*  - Benachrichtigungen
*   - An/Aus
*   - Zeitintervall
*  (evtl einfach die normalen einstellungen als Widget laden anstatt zu kopieren?)
* Lademodus:
*  - selbsterklärend
* */

final _klassenStufeController = TextEditingController();
final _klassenController = TextEditingController();
final _lehrerKuerzelController = TextEditingController();

List<PageViewModel> setupScreenPageViewModels = [
  if (client.doesSupportFeature("Vertretungsplan")) ...[
    PageViewModel(
        image: SvgPicture.asset("assets/undraw/undraw_filter_re_sa16.svg", height: 175.0),
        title: "Vertretungen filtern",
        body: "Damit du die Vertretungen, die für dich bestimmt sind, schneller finden kannst, gibt es ein Filter-Feature! Der Filter sucht in den Einträgen nach deiner Klassenstufe, Klasse und Lehrer des Faches."
    ),
    PageViewModel(
        image: SvgPicture.asset("assets/undraw/undraw_content_re_33px.svg", height: 175.0),
        title: "Filter- und Vertretungsplanvoraussetzung",
        body: "Damit du mit dem Filter (und das Anzeigen der Vertretungen) die bestmögliche Erfahrung hast, muss die Schule die Einträge vollständig angeben, z. B. haben manche Schulen nicht die Lehrer der Fächer in ihren Einträgen richtig angegeben und geben stattdessen die Vertretung oder nichts an."
    ),
    PageViewModel(
      useScrollView: true,
      image: SvgPicture.asset("assets/undraw/undraw_wireframing_re_q6k6.svg", height: 175.0),
      title: "Beispiele für Einträge",
      bodyWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Text(
                "Beispiel für einen vollständigen Eintrag",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Card(
            child: SubstitutionWidget(substitutionData: {
              "Stunde": "1 - 2",
              "Klasse": "Q3/4",
              "Vertreter": "KAP",
              "Lehrer": "GIP",
              "Raum": "E1.14",
              "Fach": "D",
              "Art": "Vertretung"
            }),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 2.0),
            child: Text(
              "Beispiel für einen unvollständigen Eintrag",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Card(
            child: SubstitutionWidget(substitutionData: {
              "Stunde": "1 - 2",
              "Vertreter": "KAP",
              "Hinweis": "Fällt aus"
            }),
          ),
          Text(
            "Wenn du solche Einträge siehst, solltest du dich an deine Schulleitung/Schul-IT wenden, um dieses Problem zu lösen.",
          ),
        ],
      )
    ),
    PageViewModel(
        image: SvgPicture.asset("assets/undraw/undraw_settings_re_b08x.svg", height: 175.0),
        title: "Filtereinstellungen",
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterElements(
              klassenStufeController: _klassenStufeController,
              klassenController: _klassenController,
              lehrerKuerzelController: _lehrerKuerzelController,
            )
          ],
        )
    ),
  ],
  PageViewModel(
      image: SvgPicture.asset("assets/undraw/undraw_access_account_re_8spm.svg", height: 175.0),
      title: "Du bist jetzt bereit!",
      body: "Du kannst lanis-mobile jetzt verwenden. Wenn die die App gefällt, kannst du gerne eine Bewertung im Play Store machen."
  ),
];