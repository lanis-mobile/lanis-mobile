import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../client/client.dart';
import 'filterlogic.dart';
import 'filtersettings.dart';

class VertretungsplanAnsicht extends StatefulWidget {
  const VertretungsplanAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _VertretungsplanAnsichtState();
}

class _VertretungsplanAnsichtState extends State<VertretungsplanAnsicht> {
  double padding = 10.0;

  final random = Random();

  @override
  void initState() {
    super.initState();
    refreshPlan();
  }

  List<CardInfo> cards = [];

  void showSnackbar(String text, {seconds = 1, milliseconds = 0}) {
    if (mounted) {
      // Hide the current SnackBar if one is already visible.
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          duration: Duration(seconds: seconds, milliseconds: milliseconds),
        ),
      );
    }
  }

  Future<void> refreshPlan({secondTry = false}) async {
    if (mounted) {
      //preloader
      setState(() {
        cards = [
          CardInfo(
              title: const Text("Lade Plan..."),
              body: const SpinKitRing(
                size: 80,
                color: Colors.black,
              ),
              footer: const Text("")
          )
        ];
      });

      final vPlan = await client.getFullVplan();
      if (vPlan is int) {
        showSnackbar(client.statusCodes[vPlan]??"Unbekannter Fehler");
      } else {
        // filter and render cards
        final filteredPlan = await filter(vPlan);

        setState(() {
          cards.clear();

          final List<String> keysNotRender = [
            "Tag",
            "Tag_en",
            "Klasse",
            "Stunde",
            "_sprechend",
            "_hervorgehoben",
            "Art",
            "Fach"
          ];

          for (final entry in filteredPlan) {
            List<Widget> cardBody = [];

            String hinweis = "";
            entry.forEach((key, value) {
              if ((!keysNotRender.contains(key) &&
                  value != null &&
                  value != "")) {
                if (key != "Hinweis") {
                  cardBody.add(Padding(
                      padding: const EdgeInsets.only(right: 30, left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("$key:"), Text(value)],
                      )));
                } else {
                  hinweis = value;
                }
              }
            });

            if (hinweis != "") {
              cardBody.add(Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: Text("Hinweis:  $hinweis"),
              ));
            }

            cards.add(CardInfo(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry['Art'],
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(entry["Klasse"]),
                  Text(
                    entry['Stunde'],
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ),
              body: Wrap(
                spacing: 0,
                children: cardBody,
              ),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDateString(entry["Tag_en"], entry["Tag"]),
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    entry["Fach"] ?? "",
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
            ));
          }

          //card to render always on bottom
          cards.add(CardInfo(
            title: const Text("keine weiteren Einträge", style: TextStyle(fontSize: 22)),
            body: const Text("Alle Angaben ohne gewähr! Die Funktionalität der App hängt stark von der verwendeten Schule und den eingestellten Filtern ab!"),
            footer: const Text("alessioC42")
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshPlan,
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding:
              EdgeInsets.only(left: padding, right: padding, bottom: padding),
              child: Card(
                child: ListTile(
                  title: cards[index].title,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cards[index].body,
                      cards[index].footer,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FilterPlan()),
              );
              await refreshPlan();
            },
            heroTag: null,
            child: const Icon(Icons.filter_alt),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: refreshPlan,
            heroTag: null,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class CardInfo {
  final Widget title;
  final Widget body;
  final Widget footer;

  CardInfo({
    required this.title,
    required this.body,
    required this.footer,
  });
}
