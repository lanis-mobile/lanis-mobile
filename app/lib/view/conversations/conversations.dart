import 'package:flutter/material.dart';
import 'package:sph_plan/view/conversations/detailed_conversation.dart';

import '../../client/client.dart';
import '../../client/fetcher.dart';
import '../bug_report/send_bugreport.dart';

class ConversationsAnsicht extends StatefulWidget {
  const ConversationsAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _ConversationsAnsichtState();
}

class _ConversationsAnsichtState extends State<ConversationsAnsicht>
    with TickerProviderStateMixin {
  static const double padding = 12.0;

  final GlobalKey<RefreshIndicatorState> _refreshVisibleKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshInvisibleKey =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _errorIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  dynamic visibleConversations;
  dynamic invisibleConversations;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    client.visibleConversationsFetcher.fetchData();
    client.invisibleConversationsFetcher.fetchData();

    super.initState();
  }

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

  Widget conversationsView(BuildContext context, conversations, Fetcher fetcher, GlobalKey key) {
    return RefreshIndicator(
      key: key,
      onRefresh: () async {
        fetcher.fetchData(forceRefresh: true);
      },
      child: ListView.builder(
        itemCount: conversations.length + 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
                left: padding, right: padding, bottom: padding),
            child: Card(
              child: InkWell(
                  onTap: () {
                    if (index == conversations.length) {
                      showSnackbar("(:");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailedConversationAnsicht(
                                    uniqueID: conversations[index]
                                    ["Uniquid"], // nice typo Lanis
                                    title: conversations[index]
                                    ["Betreff"],
                                  )));
                    }
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: index == conversations.length
                      ? _tabController.index == 0
                      ? infoCard
                      : infoCardInvisibility
                      : getConversationWidget(conversations[index])),
            ),
          );
        },
      ),
    );
  }

  Widget errorView(BuildContext context, FetcherResponse? response, Fetcher fetcher) {
    return RefreshIndicator(
      key: _errorIndicatorKey,
      onRefresh: () async {
        fetcher.fetchData(forceRefresh: true);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  size: 60,
                ),
                const Padding(
                  padding: EdgeInsets.all(35),
                  child: Text(
                      "Es gibt wohl ein Problem, bitte sende einen Fehlerbericht!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22)),
                ),
                Text(
                    "Problem: ${client.statusCodes[response!.content] ?? "Unbekannter Fehler"}"),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BugReportScreen(
                                      generatedMessage:
                                      "AUTOMATISCH GENERIERT:\nEin Fehler ist bei Nachrichten aufgetreten:\n${response.content}: ${client.statusCodes[response.content]}\n\nMehr Details von dir:\n")),
                            );
                          },
                          child:
                          const Text("Fehlerbericht senden")),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: OutlinedButton(
                            onPressed: () async {
                              fetcher.fetchData(forceRefresh: true);
                            },
                            child: const Text("Erneut versuchen")),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
              stream: client.visibleConversationsFetcher.stream,
              builder: (context, snapshot) {
                if (snapshot.data?.status == FetcherStatus.error) {
                  return errorView(context, snapshot.data, client.visibleConversationsFetcher);
                } else if (snapshot.data?.status == FetcherStatus.fetching || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return conversationsView(context, snapshot.data?.content, client.visibleConversationsFetcher, _refreshVisibleKey);
                }
              }
          ),
          StreamBuilder(
              stream: client.invisibleConversationsFetcher.stream,
              builder: (context, snapshot) {
                if (snapshot.data?.status == FetcherStatus.error) {
                  return errorView(context, snapshot.data, client.invisibleConversationsFetcher);
                } else if (snapshot.data?.status == FetcherStatus.fetching || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return conversationsView(context, snapshot.data?.content, client.invisibleConversationsFetcher, _refreshInvisibleKey);
                }
              }
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refreshVisibleKey.currentState?.show();
          _refreshInvisibleKey.currentState?.show();
          _errorIndicatorKey.currentState?.show();
        },
        heroTag: "RefreshConversations",
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
