import 'package:flutter/material.dart';
import '../../client/client.dart';
import 'filterlogic.dart';
import 'dart:math';

import 'filtersettings.dart';

class VertretungsplanAnsicht extends StatefulWidget {
  const VertretungsplanAnsicht({super.key});

  @override
  _VertretungsplanAnsichtState createState() => _VertretungsplanAnsichtState();
}

class _VertretungsplanAnsichtState extends State<VertretungsplanAnsicht> {
  double padding = 10.0;

  final random = Random();

  _VertretungsplanAnsichtState() {
    refreshPlan();
  }

  List<CardInfo> cards = [
    CardInfo(
      title: const Text("Alle Angaben ohne Gewähr!"),
      body: const Text("Auch die besten technischen Systeme machen Fehler!"),
      footer: const Text(""),
    ),
  ];

  void showSnackbar(String text, {seconds = 1, milliseconds = 0}) {
    if (mounted) {
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
      showSnackbar("Lade Plan herunter...", milliseconds: 250);
    }

    final vPlan = await client.getFullVplan();
    debugPrint(vPlan.toString());

    if (mounted) {
      if (vPlan is int) {
        if (!secondTry) {
          showSnackbar("Melde Benutzer an...");
          await client.loadCreditsFromStorage();
          await client.login();
          await refreshPlan(secondTry: true);
        } else {
          showSnackbar(client.statusCodes[vPlan] ?? "Unbekannter Fehler");
        }
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
            "Art"
          ];

          for (final entry in filteredPlan) {
            List<Widget> chips = [];
            entry.forEach((key, value) {
              if (!keysNotRender.contains(key) &&
                  value != null &&
                  value != "") {
                final randomColor = Color.fromRGBO(
                  random.nextInt(64) + 192,
                  random.nextInt(64) + 192,
                  random.nextInt(64) + 192,
                  1,
                );

                chips.add(Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Chip(
                    label: Text(
                      "$key: $value",
                      style: const TextStyle(fontSize: 14),
                    ),
                    labelPadding: const EdgeInsets.all(1),
                    padding: const EdgeInsets.all(1),
                    backgroundColor: randomColor,
                  ),
                ));
              }
            });

            cards.add(CardInfo(
              title: Text(
                  "${entry["Klasse"]} | Stunde ${entry['Stunde']} | ${entry['Art']}"),
              body: Wrap(
                spacing: 0,
                children: chips,
              ),
              footer: Text(formatDateString(entry["Tag_en"], entry["Tag"])),
            ));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => filterPlan()),
              );
              debugPrint("HERE I AM, ROCK YOU LIKE A HURRICANE");
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
