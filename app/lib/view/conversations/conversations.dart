import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sph_plan/view/conversations/detailed_conversation.dart';

import '../../client/client.dart';

class ConversationsAnsicht extends StatefulWidget {
  const ConversationsAnsicht({super.key});

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

  bool forceNewData = true;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late StreamController _streamController;

  dynamic visibleConversations;
  dynamic invisibleConversations;

  // Get new conversation data and cache it.
  Future<dynamic> fetchConversations({secondTry= false}) async {
    try {
      if (secondTry) {
        await client.login();
      }

      if (currentPageIndex == 0) {
        if (forceNewData) {
          visibleConversations = await client.getConversationsOverview(false);
        } else {
          visibleConversations ??= await client.getConversationsOverview(false);
          forceNewData = true; // Default is true because pulling down and FAB force refreshes data, only switching between tabs uses cached.
        }
        return visibleConversations;
      }
      else {
        if (forceNewData) {
          invisibleConversations = await client.getConversationsOverview(true);
        } else {
          invisibleConversations ??= await client.getConversationsOverview(true);
          forceNewData = true;
        }
        return invisibleConversations;
      }
    } catch (e) {
      if (!secondTry) {
        fetchConversations(secondTry: true);
      }
    }
  }

  // For initState()
  void loadConversations() async {
    final conversations = await fetchConversations();
    _streamController.add(conversations);
  }

  // For RefreshIndicator()
  Future<void> refreshConversations() async {
    final conversations = await fetchConversations();
    _streamController.add(conversations);
  }

  @override
  void initState() {
    _streamController = StreamController();
    loadConversations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _streamController.stream,
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
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: refreshConversations,
              child: ListView.builder(
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
              ),
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
            // Do not force new data
            forceNewData = false;
            currentPageIndex = index;
            _refreshIndicatorKey.currentState?.show();
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            label: "Eingeblendete Nachrichten",
            icon: Icon(Icons.visibility),
            selectedIcon: Icon(Icons.visibility_outlined),
          ),
          NavigationDestination(
              label: "Ausgeblendete Nachrichten",
              icon: Icon(Icons.visibility_off),
              selectedIcon: Icon(Icons.visibility_off_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refreshIndicatorKey.currentState?.show();
        },
        heroTag: null,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
