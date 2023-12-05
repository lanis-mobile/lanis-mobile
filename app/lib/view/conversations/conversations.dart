import 'package:flutter/material.dart';
import 'package:sph_plan/view/conversations/detailed_conversation.dart';

import '../../client/client.dart';

class ConversationsAnsicht extends StatefulWidget {
  const ConversationsAnsicht({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationsAnsichtState();
}

class _ConversationsAnsichtState extends State<ConversationsAnsicht> {
  int currentPageIndex = 0;
  static const double padding = 10.0;

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

  // Borrowed from vertretungsplan.dart
  Widget infoCard = const ListTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: Text(
            "Keine weiteren Einträge!",
            style: TextStyle(fontSize: 21),
          ),
        ),
      ],
    ),
    subtitle: Text(
      "Alle Angaben ohne Gewähr. \nDie Funktionalität der App hängt stark von der verwendeten Schule und den eingestellten Filtern ab.",
    ),
  );

  Widget infoCardInvisibility = const ListTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: Text(
            "Hinweis",
            style: TextStyle(fontSize: 21),
          ),
        ),
      ],
    ),
    subtitle: Text(
      "Du kannst auf Lanis Unterhaltungen ausblenden. Diese Unterhaltungen löschen sich automatisch nach einer Zeit, aber werden wieder eingeblendet, wenn sie aktiv werden.",
    ),
  );

  Widget getConversationWidget(Map<String, dynamic> conversation) {
    return ListTile(
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                conversation["Datum"] ??
                    "", // TODO: maybe convert the date later
              )
            ],
          ),
        ],
      ),
      leading: conversation["unread"] != null && conversation["unread"] == 1
          ? const Icon(Icons.notification_important)
          : null,
    );
  }

  final Future<dynamic> _getVisibleConversationOverview =
      client.getConversationsOverview(false);

  final Future<dynamic> _getInvisibleConversationOverview =
      client.getConversationsOverview(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: currentPageIndex == 0
            ? _getVisibleConversationOverview
            : _getInvisibleConversationOverview,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            // If a error happened
            if (snapshot.data is int) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning,
                    size: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(50),
                    child: Text(
                        "Es gibt wohl ein Problem, bitte kontaktiere den Entwickler der App!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22)),
                  ),
                  Text(
                      "Problem: ${client.statusCodes[snapshot.data] ?? "Unbekannter Fehler"}")
                ],
              ));
            }

            // Successful content
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: padding, right: padding, bottom: padding),
                  child: Card(
                    child: InkWell(
                        onTap: () {
                          if (index == snapshot.data.length) {
                            showSnackbar("(:");
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailedConversationAnsicht(
                                          uniqueID: snapshot.data[index]
                                              ["Uniquid"], // nice typo Lanis
                                          title: snapshot.data[index]
                                              ["Betreff"],
                                        )));
                          }
                        },
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: index == snapshot.data.length
                            ? currentPageIndex == 0
                                ? infoCard
                                : infoCardInvisibility
                            : getConversationWidget(snapshot.data[index])),
                  ),
                );
              },
            );
          }
          // Waiting content
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        },
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.visibility), label: "Eingeblendete Nachrichten"),
          NavigationDestination(
              icon: Icon(Icons.visibility_off),
              label: "Ausgeblendete Nachrichten")
        ],
      ),
    );
  }
}