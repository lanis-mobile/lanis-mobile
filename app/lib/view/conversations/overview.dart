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


  ListTile getConversationWidget(Map<String, dynamic> conversation) {
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
          if (index == conversations.length) {
            return ListTile(
                title: Center(
                  child: Text(
                    AppLocalizations.of(context)!.noFurtherEntries,
                    style: const TextStyle(fontSize: 21),
                  ),
                ),
              subtitle: Center(
                child: Text(
                  AppLocalizations.of(context)!.notificationsNote,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            );
          }

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConversationsChat(
                        id: conversations[index]
                        ["Uniquid"], // nice typo Lanis
                        title: conversations[index]["Betreff"],
                      ),
                    ),
                  );
                },
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: getConversationWidget(conversations[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  void showCreationDialog(ChatType? chatType) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.createNewConversation),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    subjectController.clear();
                    receivers.clear();
                    rebuildSearch.trigger();
                  },
                  heroTag: "clearAll",
                  icon: const Icon(Icons.clear_all),
                  label: Text(AppLocalizations.of(context)!.clearAll)
              ),
            ),
            FloatingActionButton.extended(
                onPressed: () async {
                  if (subjectController.text.isEmpty || receivers.isEmpty) {
                    return;
                  }

                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationsSend(
                          creationData: ChatCreationData(
                              type: chatType,
                              subject: subjectController.text,
                              receivers: receivers
                                  .map((entry) => entry.id)
                                  .toList()),
                        )),
                  ).then((_) {
                    subjectController.clear();
                    receivers.clear();
                    visibleConversationsFetcher.fetchData(forceRefresh: true);
                  },
                  );
                },
                icon: const Icon(Icons.create),
                label: Text(AppLocalizations.of(context)!.create)
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(padding),
              child: TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.subject,
                ),
                maxLines: null,
                autofocus: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: padding, right: padding, bottom: padding),
            child: ListenableBuilder(
              listenable: rebuildSearch,
              builder: (context, widget) {
                return FlutterTagging<ReceiverEntry>(
                  initialItems: receivers,
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .addReceiversHint,
                      labelText: AppLocalizations.of(context)!
                          .addReceivers,
                    ),
                  ),
                  configureSuggestion: (entry) {
                    return SuggestionConfiguration(
                        title: Text(entry.name),
                        leading: Icon(entry.isTeacher ? Icons.school : Icons.person),
                        subtitle: entry.isTeacher ? Text(AppLocalizations.of(context)!.teacher) : null,
                    );
                  },
                  configureChip: (entry) {
                    return ChipConfiguration(
                      label: Text(entry.name),
                      avatar: Icon(entry.isTeacher ? Icons.school : Icons.person),
                    );
                  },
                  loadingBuilder: (context) {
                    return ListTile(
                      leading: const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      ),
                      title: Text(AppLocalizations.of(context)!.loading),
                    );

                  },
                  emptyBuilder: (context) {
                    if (connectionChecker.status == ConnectionStatus.disconnected) {
                      return ListTile(
                        leading: const Icon(Icons.wifi_off),
                        title: Text(AppLocalizations.of(context)!.noInternetConnection),
                      );
                    }

                    return ListTile(
                      leading: const Icon(Icons.person_off),
                      title: Text(AppLocalizations.of(context)!.noPersonFound),
                    );
                  },
                  onAdded: (receiverEntry) {
                    return receiverEntry;
                  },
                  findSuggestions: (query) async {
                    query = query.trim();
                    if (query.isEmpty) return <ReceiverEntry>[];

                    final dynamic result = await client
                        .conversations
                        .searchTeacher(query);
                    return result;
                  },
                );
              },
            ),),
          ],
        ),
      ))
    );
  }

  void showTypeChooser() {
    const List<ChatType> chatTypes = ChatType.values;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.conversationType),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Theme(
            data: Theme.of(context),
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
                          Text(AppLocalizations.of(context)!
                              .conversationTypeName(
                              chatTypes[index].name)),
                          if (chatTypes[index] == ChatType.openChat) ...[
                            Text(
                              AppLocalizations.of(context)!
                                  .experimental
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ]
                        ],
                      ),
                      initiallyExpanded: true,
                      leading: Icon(chatTypes[index].icon),
                      collapsedBackgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHigh,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHigh,
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      children: [
                        Container(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .conversationTypeDescription(
                                      chatTypes[index].name),
                                  textAlign: TextAlign.start,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      FilledButton(
                                          onPressed: () {
                                            return showCreationDialog(
                                                chatTypes[index]);
                                          },
                                          child: Text(AppLocalizations.of(
                                              context)!
                                              .select)),
                                    ],
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  );
                }),
          ),
        ),
      ))
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
                        error: snapshot.data?.content,
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
        floatingActionButton: FutureBuilder(
          future: client.conversations.canChooseType(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return FloatingActionButton(
                onPressed: () {
                  if (snapshot.data!) {
                    showTypeChooser();
                  } else {
                    showCreationDialog(null);
                  }
                },
                child: const Icon(Icons.edit),
              );
            }
            return const FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.edit),
            );
          },
        ));
  }
}
