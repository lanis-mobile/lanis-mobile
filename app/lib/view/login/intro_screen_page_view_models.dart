import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<PageViewModel> intoScreenPageViewModels = [
  PageViewModel(
    image: SvgPicture.asset("assets/undraw/undraw_welcome_re_h3d9.svg", height: 175.0),
    title: "Willkommen",
    body: "lanis-mobile hilft bei den täglichen Aufgaben des Schulportals. Ob Vertretungsplan oder Kalender, Nachrichten oder Kurshefte. Mit lanis-mobile kannst du effizienter und einfacher lernen.",
  ),
  PageViewModel(
      image: SvgPicture.asset("assets/undraw/undraw_engineering_team_a7n2.svg", height: 175.0),
      title: "Von Schülern. Für Schüler.",
      body: "Diese Anwendung wird von Schülern entwickelt, die das Schulportal Hessen nutzen.\n\nDank an alle Entwickler und Bug Reporter"
  ),
  PageViewModel(
      image: SvgPicture.asset("assets/undraw/undraw_editable_re_4l94.svg", height: 175.0),
      title: "Anpassung",
      body: "In den Einstellungen kannst du die App auf deine Bedürfnisse anpassen."
  ),
  PageViewModel(
      image: SvgPicture.asset("assets/undraw/undraw_building_blocks_re_5ahy.svg", height: 175.0),
      title: "Das Schulportal Hessen",
      body: "Das Schulportal ist Modular aufgebaut. Das bedeutet, dass deine Schule vielleicht nicht alle Features der App unterstützt oder die App nicht alle Features deiner Schule."
  ),
  PageViewModel(
      image: SvgPicture.asset("assets/undraw/undraw_bug_fixing_oc-7-a.svg", height: 175.0),
      title: "Fehlerbehebungen und Analyse",
      body: "Wegen der modularen Natur des Schulportals kann es vereinzelt zu Problem für deine Schule kommen. Sende uns in diesem Fall bitte einen Fehlerbericht. Wenn die App intern einen Fehler erkennt wird dieser auch automatisch anonym an die Entwickler gesendet um eine möglichst robuste Anwendung zur schaffen."
  ),
  PageViewModel(
      image: SvgPicture.asset("assets/undraw/undraw_access_account_re_8spm.svg", height: 175.0),
      title: "Worauf wartest du?",
      body: "Melde dich jetzt an um lanis-mobile zu nutzen. Verwende dafür die Logindaten, die du Normalerweise für die Webseite des Schulportals verwendest."
  ),
];