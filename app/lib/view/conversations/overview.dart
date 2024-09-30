import 'package:flutter/material.dart';
import 'package:sph_plan/client/client_submodules/conversations.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:sph_plan/shared/types/conversations.dart';

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
  static const individualIcons = {
    SearchFunction.subject: Icon(Icons.subject),
    SearchFunction.name: Icon(Icons.person),
    SearchFunction.schedule: Icon(Icons.calendar_today)
  };

  static final TextEditingController searchController = TextEditingController();
  static final individualControllers = {
    SearchFunction.subject: TextEditingController(),
    SearchFunction.name: TextEditingController(),
    SearchFunction.schedule: TextEditingController()
  };

  static var removeButton = false;
  static var removeButtons = {
    SearchFunction.subject: false,
    SearchFunction.name: false,
    SearchFunction.schedule: false
  };

  final ConversationsFetcher conversationsFetcher =
      client.fetchers.conversationsFetcher;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
  GlobalKey<RefreshIndicatorState>();
  final ValueNotifier<bool> showHidden = ValueNotifier(false);

  bool expand = false;

  @override
  void initState() {
    conversationsFetcher.fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size(double.maxFinite, expand ? 200 : 16),
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 0, bottom: 8),
                child: Column(
                  children: [
                    if (expand) ...[
                      ...List<Padding>.generate(
                          client.conversations.filter.individual.length, (i) {
                        SearchFunction function = client
                            .conversations.filter.individual.keys
                            .elementAt(i);

                        filterFunction(String text) {
                          client.conversations.filter.individual[function] =
                              text;
                          client.conversations.filter.supply();

                          if (text.isEmpty) {
                            setState(() {
                              removeButtons[function] = false;
                            });
                          }

                          if (removeButtons[function] == false &&
                              text.isNotEmpty) {
                            setState(() {
                              removeButtons[function] = true;
                            });
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SearchBar(
                            hintText: AppLocalizations.of(context)!
                                .individualSearchHint(function.name),
                            textInputAction: TextInputAction.search,
                            controller: individualControllers[function],
                            onSubmitted: filterFunction,
                            onChanged: filterFunction,
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: individualIcons[function],
                            ),
                            trailing: [
                              Visibility(
                                visible: removeButtons[function]!,
                                child: IconButton(
                                    onPressed: () {
                                      client.conversations.filter
                                          .individual[function] = "";
                                      individualControllers[function]!.clear();
                                      client.conversations.filter.supply();

                                      setState(() {
                                        removeButtons[function] = false;
                                      });
                                    },
                                    icon: const Icon(Icons.delete)),
                              )
                            ],
                          ),
                        );
                      })
                    ],
                    SearchBar(
                      hintText: AppLocalizations.of(context)!.searchHint,
                      textInputAction: TextInputAction.search,
                      controller: searchController,
                      onSubmitted: (String text) {
                        client.conversations.filter.searchText = text;
                        client.conversations.filter.supply();
                      },
                      onChanged: (String text) {
                        client.conversations.filter.searchText = text;
                        client.conversations.filter.supply();

                        if (text.isEmpty) {
                          setState(() {
                            removeButton = false;
                          });
                        }

                        if (removeButton == false && text.isNotEmpty) {
                          setState(() {
                            removeButton = true;
                          });
                        }
                      },
                      trailing: [
                        Visibility(
                          visible: removeButton,
                          child: IconButton(
                              onPressed: () {
                                client.conversations.filter.searchText = "";
                                searchController.clear();
                                client.conversations.filter.supply();

                                setState(() {
                                  removeButton = false;
                                });
                              },
                              icon: const Icon(Icons.delete)),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                expand = !expand;
                              });
                            },
                            icon: expand
                                ? const Icon(Icons.expand_less)
                                : const Icon(Icons.expand_more))
                      ],
                    ),
                  ],
                )),
          ),
        ),
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
                return RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: () async {
                    conversationsFetcher.fetchData(forceRefresh: true);
                  },
                  child: ListView.builder(
                      itemCount: snapshot.data?.content.length + 2,
                      itemExtent: 80,
                      itemBuilder: (context, index) {
                        if (index > snapshot.data?.content.length - 1) {
                          return const SizedBox.shrink();
                        }

                        return ConversationTile(
                          entry: snapshot.data?.content[index],
                        );
                      }),
                );
              }
            }),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ValueListenableBuilder(
                valueListenable: showHidden,
                builder: (context, show, _) {
                  return FloatingActionButton(
                    heroTag: "visibility",
                    onPressed: () async {
                      showHidden.value = !showHidden.value;
                      client.conversations.filter.showHidden = showHidden.value;
                      client.conversations.filter.supply();
                    },
                    child: show
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  );
                }),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () async {
                bool canChooseType;
                try {
                  canChooseType = await client.conversations.canChooseType();
                } on NoConnectionException {
                  return;
                }

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  if (canChooseType) {
                    return const TypeChooser();
                  }
                  return const CreateConversation(chatType: null);
                }));
              },
              child: const Icon(Icons.edit),
            ),
          ],
        ));
  }
}

class ConversationTile extends StatefulWidget {
  final OverviewEntry entry;

  const ConversationTile({super.key, required this.entry});

  @override
  State<ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        margin: const EdgeInsets.all(0),
        color: widget.entry.hidden
            ? Theme.of(context)
            .colorScheme
            .surfaceContainerLow
            .withOpacity(0.75)
            : null,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if (widget.entry.unread == true) {
                    client.conversations.filter
                        .toggleEntry(widget.entry.id, unread: true);
                  }

                  return ConversationsChat.fromEntry(widget.entry);
                },
              ),
            );
          },
          customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.entry.hidden) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 64.0),
                      child: Icon(
                        Icons.visibility_off,
                        color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context)
                            .colorScheme
                            .surfaceContainerHigh
                            .withOpacity(0.4)
                            : Theme.of(context)
                            .colorScheme
                            .surfaceContainerLow
                            .withOpacity(0.75),
                        size: 65,
                      ),
                    ),
                  ],
                ),
              ],
              Badge(
                smallSize: widget.entry.unread ? 9 : 0,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Text(
                          widget.entry.title,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      if (widget.entry.shortName != null) ...[
                        Flexible(
                          child: Text(
                            widget.entry.shortName!,
                            overflow: TextOverflow.ellipsis,
                            style: widget.entry.shortName != null
                                ? Theme.of(context).textTheme.titleMedium
                                : Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error),
                          ),
                        ),
                      ]
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.entry.date,
                      ),
                      Text(
                        widget.entry.fullName,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}