import 'package:flutter/material.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:sph_plan/shared/types/conversations.dart';
import 'package:sph_plan/view/conversations/send.dart';

import '../../client/client.dart';
import '../../client/connection_checker.dart';
import '../../client/fetcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../shared/widgets/error_view.dart';
import 'chat.dart';

class TriggerRebuild with ChangeNotifier {
  void trigger() {
    notifyListeners();
  }
}

class ConversationsOverview extends StatefulWidget {
  const ConversationsOverview({super.key});

  @override
  State<StatefulWidget> createState() => _ConversationsOverviewState();
}

class _ConversationsOverviewState extends State<ConversationsOverview>
    with TickerProviderStateMixin {
  static const double padding = 12.0;

  final InvisibleConversationsFetcher invisibleConversationsFetcher =
      client.fetchers.invisibleConversationsFetcher;
  final VisibleConversationsFetcher visibleConversationsFetcher =
      client.fetchers.visibleConversationsFetcher;

  final GlobalKey<RefreshIndicatorState> _refreshVisibleKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshInvisibleKey =
      GlobalKey<RefreshIndicatorState>();

  dynamic visibleConversations;
  dynamic invisibleConversations;

  late TabController _tabController;

  final TextEditingController subjectController = TextEditingController();
  final List<ReceiverEntry> receivers = [];
  final TriggerRebuild rebuildSearch = TriggerRebuild();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    visibleConversationsFetcher.fetchData();
    invisibleConversationsFetcher.fetchData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    subjectController.dispose();
    rebuildSearch.dispose();
    _tabController.dispose();
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
                              builder: (context) => ConversationsChat(id: conversations[index]
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
          title: const Text("Neue Konversation erstellen"),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                          hintText: 'Betreff',
                      ),
                    ),
                  ),
                  ListenableBuilder(
                    listenable: rebuildSearch,
                    builder: (context, widget) {
                      return FlutterTagging<ReceiverEntry>(
                        initialItems: receivers,
                        textFieldConfiguration: const TextFieldConfiguration(
                          decoration: InputDecoration(
                            hintText: "z. B. Namen oder Abkürzungen",
                            labelText: "Empfänger hinzufügen",
                          ),
                        ),
                        onAdded: (receiverEntry) {
                          return receiverEntry;
                        },
                        configureChip: (tag) {
                          return ChipConfiguration(
                              label: Text(tag.name),
                          );
                        },
                        configureSuggestion: (tag) {
                          return SuggestionConfiguration(
                              title: Text(tag.name)
                          );
                        },
                        findSuggestions: (query) async {
                          if (!(await connectionChecker.connected)) {
                            return <ReceiverEntry>[];
                          }

                          query = query.trim();
                          if (query.isEmpty) return <ReceiverEntry>[];
              
                          final dynamic result = await client.conversations.searchTeacher(query);
                          return result == false ? <ReceiverEntry>[] : result;
                        },
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  subjectController.clear();
                  receivers.clear();
                  rebuildSearch.trigger();
                },
                tooltip: "Betreff und Empfänger zurücksetzen",
                icon: const Icon(Icons.format_clear)
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Zurück")
            ),
            FilledButton(
                onPressed: () async {
                  if (subjectController.text.isEmpty || receivers.isEmpty) {
                    return;
                  }

                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConversationsSend(
                      creationData: ChatCreationData(
                          type: chatType,
                          subject: subjectController.text,
                          receivers: receivers.map((entry) => entry.id).toList()
                      ),
                    )),
                  ).then((_) {
                    subjectController.clear();
                    receivers.clear();
                  });
                },
                child: const Text("Erstellen")
            ),
          ],
        )
    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                const List<ChatType> chatTypes = ChatType.values;

                return AlertDialog(
                  title: const Text("Konversationsart"),
                  actions: [
                    OutlinedButton(
                        onPressed: () { Navigator.of(context).pop(); },
                        child: const Text("Zurück")
                    )
                  ],
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ListView.builder(
                          itemCount: ChatType.values.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ExpansionTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(chatTypes[index].descriptiveName),
                                    if (chatTypes[index] == ChatType.openChat) ...[
                                      const Text(
                                          "EXPERIMENTELL",
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                                initiallyExpanded: index == 0 ? true : false,
                                leading: Icon(chatTypes[index].icon),
                                collapsedBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                                collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)
                                ),
                                children: [
                                  Container(
                                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            chatTypes[index].description,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              FilledButton(
                                                  onPressed: () {
                                                    return showCreationDialog(chatTypes[index]);
                                                  },
                                                  child: const Text("Weiter")
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                  )
                                ],
                              ),
                            );
                          }
                      ),
                    )
                  ),
                );
              }
          );
        },
        child: const Icon(Icons.edit),
      )
    );
  }
}