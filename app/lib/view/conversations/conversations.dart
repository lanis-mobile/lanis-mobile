import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:sph_plan/shared/types/conversations.dart';

import '../../client/client.dart';
import '../../client/fetcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../shared/widgets/error_view.dart';
import 'chat.dart';

class ConversationsAnsicht extends StatefulWidget {
  const ConversationsAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _ConversationsAnsichtState();
}

class _ConversationsAnsichtState extends State<ConversationsAnsicht>
    with TickerProviderStateMixin {
  final InvisibleConversationsFetcher invisibleConversationsFetcher =
      client.fetchers.invisibleConversationsFetcher;
  final VisibleConversationsFetcher visibleConversationsFetcher =
      client.fetchers.visibleConversationsFetcher;

  static const double padding = 12.0;

  final GlobalKey<RefreshIndicatorState> _refreshVisibleKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshInvisibleKey =
      GlobalKey<RefreshIndicatorState>();

  dynamic visibleConversations;
  dynamic invisibleConversations;

  late TabController _tabController;

  final TextEditingController receiversController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    visibleConversationsFetcher.fetchData();
    invisibleConversationsFetcher.fetchData();

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

  Widget infoCard(context) => ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                AppLocalizations.of(context)!.noFurtherEntries,
                style: const TextStyle(fontSize: 21),
              ),
            ),
          ],
        ),
      );

  Widget infoCardInvisibility(context) => ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                AppLocalizations.of(context)!.note,
                style: const TextStyle(fontSize: 21),
              ),
            ),
          ],
        ),
        subtitle: Text(
          AppLocalizations.of(context)!.notificationsNote,
          style: const TextStyle(fontSize: 17),
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
                conversation["Datum"] ?? "",
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

  Widget conversationsView(
      BuildContext context, conversations, Fetcher fetcher, GlobalKey key) {
    return RefreshIndicator(
      key: key,
      onRefresh: () async {
        fetcher.fetchData(forceRefresh: true);
      },
      child: ListView.builder(
        itemCount: conversations.length + 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: padding,
              right: padding,
              bottom: index == conversations.length ? 14 : 8,
              top: index == 0 ? padding : 0,
            ),
            child: Card(
              child: InkWell(
                  onTap: () {
                    if (index == conversations.length) {
                      showSnackbar("(:");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConversationsChat(uniqueID: conversations[index]
                              ["Uniquid"], // nice typo Lanis
                                title: conversations[index]["Betreff"],))
                      );
                    }
                  },
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: index == conversations.length
                      ? _tabController.index == 0
                          ? infoCard(context)
                          : infoCardInvisibility(context)
                      : getConversationWidget(conversations[index])),
            ),
          );
        },
      ),
    );
  }

  void showCreationDialog(ChatType chatType) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Neuen Gruppenchat erstellen"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(chatType.description),
              TextField(
                controller: receiversController,
                decoration: const InputDecoration(
                    hintText: 'Empfänger-IDs'
                ),
              ),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                    hintText: 'Betreff'
                ),
              )
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Zurück")
            ),
            FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConversationsChat(
                      title: subjectController.text,
                      creationData: PartialChat(
                          type: chatType,
                          subject: subjectController.text,
                          receivers: receiversController.text.split(";")
                      ),
                    )),
                  );
                },
                child: const Text("Erstellen")
            ),
          ],
        )
    ).then((value) {
      subjectController.clear();
      receiversController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            text: AppLocalizations.of(context)!.visible,
            icon: const Icon(Icons.visibility),
          ),
          Tab(
            text: AppLocalizations.of(context)!.invisible,
            icon: const Icon(Icons.visibility_off),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StreamBuilder(
              stream: visibleConversationsFetcher.stream,
              builder: (context, snapshot) {
                if (snapshot.data?.status == FetcherStatus.error) {
                  return ErrorView(
                      data: snapshot.data?.content,
                      name: AppLocalizations.of(context)!.messages,
                      fetcher: visibleConversationsFetcher);
                } else if (snapshot.data?.status == FetcherStatus.fetching ||
                    snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return conversationsView(context, snapshot.data?.content,
                      visibleConversationsFetcher, _refreshVisibleKey);
                }
              }),
          StreamBuilder(
              stream: invisibleConversationsFetcher.stream,
              builder: (context, snapshot) {
                if (snapshot.data?.status == FetcherStatus.error) {
                  return ErrorView.fromCode(
                      data: snapshot.data?.content,
                      name: AppLocalizations.of(context)!.messages,
                      fetcher: invisibleConversationsFetcher);
                } else if (snapshot.data?.status == FetcherStatus.fetching ||
                    snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return conversationsView(context, snapshot.data?.content,
                      invisibleConversationsFetcher, _refreshInvisibleKey);
                }
              })
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 70,
        type: ExpandableFabType.up,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.add)
          ),
          children: [
            FloatingActionButton.extended(
              heroTag: null,
              icon: const Icon(Icons.speaker_notes_off),
              label: const Text("Hinweis"),
              onPressed: () {
                showCreationDialog(ChatType.noAnswerAllowed);
              },
            ),
            FloatingActionButton.extended(
              heroTag: null,
              icon: const Icon(Icons.mic),
              label: const Text("Mitteilung"),
              onPressed: () {
                showCreationDialog(ChatType.privateAnswerOnly);
              },
            ),
            FloatingActionButton.extended(
              heroTag: null,
              icon: const Icon(Icons.forum),
              label: const Text("Gruppenchat"),
              onPressed: () {
                showCreationDialog(ChatType.groupOnly);
              },
            ),
            FloatingActionButton.extended(
              heroTag: null,
              icon: const Icon(Icons.groups),
              label: const Text("Offener Chat"),
              onPressed: () {
                showCreationDialog(ChatType.openChat);
              },
            ),
          ]
      ),
    );
  }
}
