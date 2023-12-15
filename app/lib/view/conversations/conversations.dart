import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sph_plan/view/conversations/detailed_conversation.dart';

import '../../client/client.dart';

class ConversationsAnsicht extends StatefulWidget {
  const ConversationsAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _ConversationsAnsichtState();
}

class _ConversationsAnsichtState extends State<ConversationsAnsicht>
    with TickerProviderStateMixin {
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

  final GlobalKey<RefreshIndicatorState> _refreshVisibleKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshInvisibleKey =
  GlobalKey<RefreshIndicatorState>();

  late final StreamController _visibleController;
  late final StreamController _invisibleController;

  late final Stream _visibleStream;
  late final Stream _invisibleStream;

  late TabController _tabController;

  dynamic visibleConversations;
  dynamic invisibleConversations;

  bool force = true;

  // Get new conversation data and cache it.
  Future<void> fetchConversations({bool secondTry = false, bool visible = true}) async {
    try {
      if (secondTry) {
        await client.login();
      }

      if ((visibleConversations == null || force == true) && visible == true) {
        visibleConversations = await client.getConversationsOverview(false);
        _visibleController.add(visibleConversations);
      } else if (visible == true) {
        _visibleController.add(visibleConversations);
        force = true;
      }

      if ((invisibleConversations == null || force == true) && visible == false) {
        invisibleConversations = await client.getConversationsOverview(true);
        _invisibleController.add(invisibleConversations);
      } else if (visible == false) {
        _invisibleController.add(invisibleConversations);
        force = true;
      }
    } catch (e) {
      if (!secondTry) {
        fetchConversations(secondTry: true);
      }
    }
  }

  @override
  void initState() {
    _visibleController = StreamController();
    _invisibleController = StreamController();

    _visibleStream = _visibleController.stream.asBroadcastStream();
    _invisibleStream = _invisibleController.stream.asBroadcastStream();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      force = false;
      if (_tabController.index == 0) {
        fetchConversations();
      } else {
        fetchConversations(visible: false);
      }
    });

    fetchConversations();
    super.initState();
  }

  Widget _listView(BuildContext context, snapshot) {
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
                    ? _tabController.index == 0
                    ? infoCard
                    : infoCardInvisibility
                    : getConversationWidget(snapshot.data[index])),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            text: "Eingeblendete Nachrichten",
            icon: Icon(Icons.visibility),
          ),
          Tab(
              text: "Ausgeblendete Nachrichten",
              icon: Icon(Icons.visibility_off),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StreamBuilder(
              stream: _visibleStream,
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
                      key: _refreshVisibleKey,
                      onRefresh: () async {
                        await fetchConversations();
                      },
                      child: _listView(context, snapshot),
                  );
                }

                // Waiting content
                return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                ));
              }
          ),
          StreamBuilder(
              stream: _invisibleStream,
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
                    key: _refreshInvisibleKey,
                    onRefresh: () async {
                      await fetchConversations(visible: false);
                    },
                    child: _listView(context, snapshot),
                  );
                }

                // Waiting content
                return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ));
              }
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _refreshVisibleKey.currentState?.show();
          } else {
            _refreshInvisibleKey.currentState?.show();
          }
        },
        heroTag: null,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
