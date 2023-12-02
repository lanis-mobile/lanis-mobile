import 'package:flutter/material.dart';

import '../../client/client.dart';

class ConversationsAnsicht extends StatefulWidget {
  const ConversationsAnsicht({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationsAnsichtState();
}

class _ConversationsAnsichtState extends State<ConversationsAnsicht> {
  double padding = 10.0;

  final CardInfo lastCard = CardInfo(
      title: const Text("Keine weiteren Einträge!", style: TextStyle(fontSize: 21)),
      body: const Text("Alle Angaben ohne Gewähr. \nDie Funktionalität der App hängt stark von der verwendeten Schule und den eingestellten Filtern ab."),
      footer: const Text("")
  );

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

  Future<List<CardInfo>?> getConversationOverview() async {
    final conversations = await client
        .getConversationsOverview();
    if (conversations is int) {
      showSnackbar(client.statusCodes[conversations] ?? "Unbekannter Fehler");
      return null;
      // TODO: ADD SECOND TRY
    } else {
      // TODO: ADD FILTER

      List<CardInfo> cards = [];

      for (final conversation in conversations) {
        cards.add(
            CardInfo(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Text(
                        conversation["Betreff"] ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 21),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        conversation["kuerzel"] ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
                footer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      conversation["Datum"] ?? "", // TODO: maybe convert the date later
                    )
                  ],
                )
            )
        );
      }

      cards.add(lastCard);

      return cards;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getConversationOverview(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            // Error content
            if (snapshot.data == null) {
              return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, size: 60,),
                      Padding(
                        padding: EdgeInsets.all(50),
                        child: Text(
                            "Es gibt wohl ein Problem, bitte kontaktiere den Entwickler der App!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22)
                        ),
                      ),
                    ],
                  )
              );
            }
            // Content
            return ListView.builder(
              itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                    EdgeInsets.only(left: padding, right: padding, bottom: padding),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          showSnackbar("Lanis hat Gnade mit dir.");
                        },
                        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: snapshot.data![index].title,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (snapshot.data![index].body != null) ...[snapshot.data![index].body!],
                              snapshot.data![index].footer,
                            ],
                          ),
                        ),
                      )
                    ),
                  );
                }
            );
          }
          // Waiting content
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            )
          );
        },
      ),
    );
  }
}

// Borrowed from vertretungsplan.dart
class CardInfo {
  final Widget title;
  final Widget footer;
  final Widget? body;

  CardInfo({
    required this.title,
    required this.footer,
    this.body
  });
}
