import 'package:flutter/material.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';

import '../../client/client.dart';
import '../../client/fetcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../shared/widgets/error_view.dart';
import 'overview_dialogs.dart';
import 'chat.dart';

class ConversationsOverview extends StatefulWidget {
  const ConversationsOverview({super.key});

  @override
  State<StatefulWidget> createState() => _ConversationsOverviewState();
}

class _ConversationsOverviewState extends State<ConversationsOverview> {
  static const double padding = 12.0;

  final ConversationsFetcher conversationsFetcher =
      client.fetchers.conversationsFetcher;

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  dynamic conversations;

  @override
  void initState() {
    conversationsFetcher.fetchData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: conversationsFetcher.stream,
            builder: (context, snapshot) {
              if (snapshot.data?.status == FetcherStatus.error) {
                return ErrorView(
                    error: snapshot.data!.error!,
                    name: AppLocalizations.of(context)!.messages,
                    retry: retryFetcher(conversationsFetcher));
              } else if (snapshot.data?.status == FetcherStatus.fetching ||
                  snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return conversationsView(context, snapshot.data?.content,
                    conversationsFetcher, _refreshKey);
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool canChooseType;
            try {
              canChooseType = await client.conversations.canChooseType();
            } on NoConnectionException {
              return;
            }

            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  if (canChooseType) {
                    return const TypeChooser();
                  }
                  return const CreateConversation(chatType: null);
                })
            );
          },
          child: const Icon(Icons.edit),
        ));
  }
}

