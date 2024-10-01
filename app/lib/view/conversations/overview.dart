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

// Global because we need them in ConversationTile and ConversationsOverview.
final scrollController = ScrollController();
final ValueNotifier<bool> hideNotifications = ValueNotifier(false);
final Map<String, bool> checkedTiles = {};

void openToggleMode() {
  hideNotifications.value = true;
  client.conversations.filter.toggleMode = true;
  client.conversations.filter.supply();
}

class ConversationsOverview extends StatefulWidget {
  const ConversationsOverview({super.key});

  @override
  State<StatefulWidget> createState() => _ConversationsOverviewState();
}

class _ConversationsOverviewState extends State<ConversationsOverview> {
  final ConversationsFetcher conversationsFetcher =
      client.fetchers.conversationsFetcher;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  static const advancedSearchIcons = {
    SearchFunction.subject: Icon(Icons.subject),
    SearchFunction.name: Icon(Icons.person),
    SearchFunction.schedule: Icon(Icons.calendar_today)
  };

  static final TextEditingController simpleSearchController =
      TextEditingController();
  static final advancedSearchControllers = {
    SearchFunction.subject: TextEditingController(),
    SearchFunction.name: TextEditingController(),
    SearchFunction.schedule: TextEditingController()
  };

  static var simpleRemoveButton = false;
  static var advancedRemoveButtons = {
    SearchFunction.subject: false,
    SearchFunction.name: false,
    SearchFunction.schedule: false
  };

  bool showHidden = false;
  bool advancedSearch = false;
  bool disableToggleButton = true;

  void closeToggleMode() {
    hideNotifications.value = false;
    client.conversations.filter.toggleMode = false;
    client.conversations.filter.supply();
    setState(() {
      disableToggleButton = false;
    });
  }

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
            preferredSize: Size(double.maxFinite, advancedSearch ? 200 : 16),
            child: ValueListenableBuilder(
                valueListenable: hideNotifications,
                builder: (context, value, _) {
                  if (value == true) {
                    return AppBar(
                      title: Text("Nachrichten aus-/einblenden"),
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      leading: IconButton(
                          onPressed: () {
                            closeToggleMode();
                            for (final tile in checkedTiles.keys) {
                              checkedTiles[tile] = false;
                            }
                          },
                          icon: Icon(Icons.arrow_back)),
                    );
                  }

                  return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 0, bottom: 8),
                      child: Column(
                        children: [
                          // Advanced search
                          if (advancedSearch) ...[
                            ...List<Padding>.generate(
                                client.conversations.filter.advancedSearch
                                    .length, (i) {
                              SearchFunction function = client
                                  .conversations.filter.advancedSearch.keys
                                  .elementAt(i);

                              filterFunction(String text) {
                                client.conversations.filter
                                    .advancedSearch[function] = text;
                                client.conversations.filter.supply();

                                if (text.isEmpty) {
                                  setState(() {
                                    advancedRemoveButtons[function] = false;
                                  });
                                }

                                if (advancedRemoveButtons[function] == false &&
                                    text.isNotEmpty) {
                                  setState(() {
                                    advancedRemoveButtons[function] = true;
                                  });
                                }
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SearchBar(
                                  hintText: AppLocalizations.of(context)!
                                      .individualSearchHint(function.name),
                                  textInputAction: TextInputAction.search,
                                  controller:
                                      advancedSearchControllers[function],
                                  onSubmitted: filterFunction,
                                  onChanged: filterFunction,
                                  leading: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: advancedSearchIcons[function],
                                  ),
                                  trailing: [
                                    Visibility(
                                      visible: advancedRemoveButtons[function]!,
                                      child: IconButton(
                                          onPressed: () {
                                            client.conversations.filter
                                                .advancedSearch[function] = "";
                                            advancedSearchControllers[function]!
                                                .clear();
                                            client.conversations.filter
                                                .supply();

                                            setState(() {
                                              advancedRemoveButtons[function] =
                                                  false;
                                            });
                                          },
                                          icon: const Icon(Icons.delete)),
                                    )
                                  ],
                                ),
                              );
                            })
                          ],

                          // Simple search
                          SearchBar(
                            hintText: AppLocalizations.of(context)!.searchHint,
                            textInputAction: TextInputAction.search,
                            controller: simpleSearchController,
                            onSubmitted: (String text) {
                              client.conversations.filter.simpleSearch = text;
                              client.conversations.filter.supply();
                            },
                            onChanged: (String text) {
                              client.conversations.filter.simpleSearch = text;
                              client.conversations.filter.supply();

                              if (text.isEmpty) {
                                setState(() {
                                  simpleRemoveButton = false;
                                });
                              }

                              if (simpleRemoveButton == false &&
                                  text.isNotEmpty) {
                                setState(() {
                                  simpleRemoveButton = true;
                                });
                              }
                            },
                            trailing: [
                              Visibility(
                                visible: simpleRemoveButton,
                                child: IconButton(
                                    onPressed: () {
                                      client.conversations.filter.simpleSearch =
                                          "";
                                      simpleSearchController.clear();
                                      client.conversations.filter.supply();

                                      setState(() {
                                        simpleRemoveButton = false;
                                      });
                                    },
                                    icon: const Icon(Icons.delete)),
                              ),
                              MenuAnchor(
                                builder: (context, controller, _) => IconButton(
                                    onPressed: () {
                                      if (controller.isOpen) {
                                        controller.close();
                                      } else {
                                        controller.open();
                                      }
                                    },
                                    icon: const Icon(Icons.more_vert)),
                                menuChildren: [
                                  MenuItemButton(
                                    leadingIcon: advancedSearch
                                        ? Icon(Icons.search_off)
                                        : Icon(Icons.search),
                                    onPressed: () {
                                      setState(() {
                                        advancedSearch = !advancedSearch;
                                      });
                                    },
                                    child: Text(advancedSearch
                                        ? "Einfache Suche"
                                        : "Erweiterte Suche"),
                                  ),
                                  MenuItemButton(
                                    leadingIcon: showHidden
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        showHidden = !showHidden;
                                      });
                                      client.conversations.filter.showHidden =
                                          showHidden;
                                      client.conversations.filter.supply();
                                    },
                                    child: Text(showHidden
                                        ? "Zeige nur Eingeblendete"
                                        : "Zeige alle"),
                                  ),
                                  const Divider(),
                                  MenuItemButton(
                                    leadingIcon: SizedBox.fromSize(
                                      size: Size(24, 0),
                                    ),
                                    onPressed: () => openToggleMode(),
                                    child: Text("Aus-/einblenden"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ));
                }),
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
                      controller: scrollController,
                      itemCount: snapshot.data?.content.length + 1,
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
        floatingActionButton: ValueListenableBuilder(
          valueListenable: hideNotifications,
          builder: (context, value, _) {
            if (value) {
              return FloatingActionButton.extended(
                  isExtended: !disableToggleButton,
                  icon: !disableToggleButton
                      ? Icon(Icons.visibility)
                      : SizedBox(
                          width: 24,
                          height: 24,
                          child: const CircularProgressIndicator(),
                        ),
                  label: Text("Aus-/einblenden"),
                  onPressed: !disableToggleButton
                      ? () async {
                          setState(() {
                            disableToggleButton = true;
                          });

                          // So you don't see each button being toggled
                          Map<String, bool> successful = {};

                          for (final tile in checkedTiles.entries) {
                            if (tile.value == true) {
                              final isHidden = client
                                  .conversations.filter.entries
                                  .where((element) => element.id == tile.key)
                                  .first
                                  .hidden;

                              late bool result;
                              try {
                                if (isHidden) {
                                  result = await client.conversations
                                      .showConversation(tile.key);
                                } else {
                                  result = await client.conversations
                                      .hideConversation(tile.key);
                                }
                              } on NoConnectionException {
                                setState(() {
                                  disableToggleButton = false;
                                });

                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          icon: const Icon(Icons.wifi_off),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .noInternetConnection2),
                                          actions: [
                                            FilledButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .back))
                                          ],
                                        ));
                                return;
                              }

                              if (!result) {
                                setState(() {
                                  disableToggleButton = false;
                                });

                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          icon: const Icon(Icons.error),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .errorOccurred),
                                          actions: [
                                            FilledButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .back))
                                          ],
                                        ));
                                return;
                              }

                              successful.addEntries([tile]);
                            }
                          }

                          for (final id in successful.keys) {
                            client.conversations.filter
                                .toggleEntry(id, hidden: true);
                            checkedTiles[id] = false;
                          }

                          closeToggleMode();
                        }
                      : null);
            }

            return FloatingActionButton(
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
            );
          },
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
                      color: Theme.of(context).brightness == Brightness.dark
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
              child: InkWell(
                onTap: () {
                  if (hideNotifications.value) {
                    setState(() {
                      checkedTiles[widget.entry.id] =
                          !(checkedTiles[widget.entry.id] ?? false);
                    });
                    return;
                  }

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
                onLongPress: () {
                  if (!hideNotifications.value) {
                    openToggleMode();
                    setState(() {
                      checkedTiles[widget.entry.id] = true;
                    });
                    final index = client.conversations.filter.entries.indexOf(widget.entry);
                    scrollController.animateTo(index * 80, duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic);
                  }
                },
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: hideNotifications,
                        builder: (context, value, _) {
                          return Visibility(
                              visible: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Icon(
                                  checkedTiles[widget.entry.id] ?? false
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ));
                        }),
                    Expanded(
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
          ],
        ),
      ),
    );
  }
}
