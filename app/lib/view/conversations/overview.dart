import 'dart:async';

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

const double tileSize = 80.0;

class ToggleModeNotification extends Notification {}

class CheckTileNotification extends Notification {
  final String? id;

  const CheckTileNotification({this.id});
}

class JumpToNotification extends Notification {
  final double? position;

  const JumpToNotification({this.position});
}

class ScrolledDownContainer extends StatefulWidget {
  final Widget child;

  const ScrolledDownContainer({super.key, required this.child});

  @override
  State<ScrolledDownContainer> createState() => _ScrolledDownContainerState();
}

class _ScrolledDownContainerState extends State<ScrolledDownContainer> {
  ScrollNotificationObserverState? scrollNotificationObserver;
  bool scrolledDown = false;

  late Color surface;
  late Color tintedSurface;

  void handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification &&
        defaultScrollNotificationPredicate(notification)) {
      final ScrollMetrics metrics = notification.metrics;
      if (scrolledDown != metrics.extentBefore > 0) {
        setState(() {
          scrolledDown = metrics.extentBefore > 0;
        });
      }
    }
  }

  void calculateColor() {
    surface = Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface;
    tintedSurface = ElevationOverlay.applySurfaceTint(
        Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
        Theme.of(context).appBarTheme.surfaceTintColor ?? Theme.of(context).colorScheme.surfaceTint,
        3);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    scrollNotificationObserver?.removeListener(handleScrollNotification);
    scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    scrollNotificationObserver?.addListener(handleScrollNotification);

    // Not perfect but better than calculating every time.
    calculateColor();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    if (scrollNotificationObserver != null) {
      scrollNotificationObserver!.removeListener(handleScrollNotification);
      scrollNotificationObserver = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scrolledDown ? tintedSurface : surface,
      ),
      child: widget.child,
    );
  }
}

class ConversationsOverview extends StatefulWidget {
  const ConversationsOverview({super.key});

  @override
  State<StatefulWidget> createState() => _ConversationsOverviewState();
}

class _ConversationsOverviewState extends State<ConversationsOverview> {
  final ConversationsFetcher fetcher = client.fetchers.conversationsFetcher;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  static const advancedSearchIcons = {
    SearchFunction.subject: Icon(Icons.subject),
    SearchFunction.name: Icon(Icons.person),
    SearchFunction.schedule: Icon(Icons.calendar_today)
  };

  static bool simpleRemoveButton = false;
  static Map<SearchFunction, bool> advancedRemoveButtons = {
    SearchFunction.subject: false,
    SearchFunction.name: false,
    SearchFunction.schedule: false
  };

  static bool showHidden = false;
  static bool advancedSearch = false;
  static bool toggleMode = false;

  final TextEditingController simpleSearchController = TextEditingController();
  final Map<SearchFunction, TextEditingController> advancedSearchControllers = {
    SearchFunction.subject: TextEditingController(),
    SearchFunction.name: TextEditingController(),
    SearchFunction.schedule: TextEditingController()
  };
  final ScrollController scrollController = ScrollController();

  final Map<String, bool> checkedTiles = {};

  bool nullContent = true;
  late StreamSubscription nullContentSubscription;

  bool loadingCreateButton = false;
  bool disableToggleButton = false;

  // Switching between two lists of overview entries messes up the scroll controller, so we just try to jump to the top visible tile and anchor to it.
  // If top tile is not visible in the new list, we try to find the first visible tile above the top tile and jump to it.
  void jumpToTopTile(
      final List<OverviewEntry> entries, final List<OverviewEntry> oldEntries) {
    final offsetTopIndex = (scrollController.offset / 80).toInt();

    double position = 0;
    if (!(entries.contains(oldEntries[offsetTopIndex]))) {
      for (int i = offsetTopIndex; i >= 0; i--) {
        if (entries.contains(oldEntries[i])) {
          final index = entries.indexOf(oldEntries[i]);
          position = index * tileSize;
          break;
        }
      }
    } else {
      final index = entries.indexOf(oldEntries[offsetTopIndex]);
      position = index * tileSize;
    }

    final viewport = scrollController.position.viewportDimension;
    final size = (entries.length + 2.5) * tileSize;

    if (size < viewport) {
      return;
    }

    if (position >= size - viewport) {
      scrollController.jumpTo(size - viewport);
    } else {
      scrollController.jumpTo(
          position + (scrollController.offset - (offsetTopIndex * tileSize)));
    }
  }

  void openToggleMode() {
    setState(() {
      toggleMode = true;
    });
    client.conversations.filter.toggleMode = true;
    client.conversations.filter.supply();
    fetcher.toggleSuspend();
  }

  void closeToggleMode() {
    setState(() {
      toggleMode = false;
    });

    final oldEntries = fetcher.stream.value.content;

    client.conversations.filter.toggleMode = false;
    client.conversations.filter.supply();

    setState(() {
      disableToggleButton = false;
    });

    fetcher.toggleSuspend();

    jumpToTopTile(fetcher.stream.value.content!, oldEntries!);
  }

  @override
  void initState() {
    fetcher.fetchData();

    nullContentSubscription = fetcher.stream.listen((snapshot) {
      setState(() {
        nullContent = snapshot.content == null;
      });
    });

    simpleSearchController.text = client.conversations.filter.simpleSearch;

    for (final value in SearchFunction.values) {
      advancedSearchControllers[value]!.text =
          client.conversations.filter.advancedSearch[value] ?? "";
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    nullContentSubscription.cancel();

    simpleSearchController.dispose();
    for (final value in SearchFunction.values) {
      advancedSearchControllers[value]!.dispose();
    }

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ToggleModeNotification) {
          if (toggleMode) {
            closeToggleMode();
          } else {
            openToggleMode();
          }
          return true;
        } else if (notification is CheckTileNotification) {
          setState(() {
            checkedTiles[notification.id!] =
                !(checkedTiles[notification.id!] ?? false);
          });
          return true;
        } else if (notification is JumpToNotification) {
          scrollController.jumpTo(notification.position!);
          return true;
        }

        return false;
      },
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(nullContent
                  ? 0
                  : advancedSearch && !toggleMode
                      ? 256
                      : 64),
              child: ScrolledDownContainer(
                child: toggleMode
                    ? SizedBox(
                        height: 64,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 4,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () {
                                  closeToggleMode();
                                  for (final tile in checkedTiles.keys) {
                                    checkedTiles[tile] = false;
                                  }
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .hideShowConversations,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    : !nullContent
                        ? Padding(
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
                                        .conversations
                                        .filter
                                        .advancedSearch
                                        .keys
                                        .elementAt(i);

                                    filterFunction(String text) {
                                      client.conversations.filter
                                          .advancedSearch[function] = text;
                                      client.conversations.filter.supply();

                                      if (text.isEmpty) {
                                        setState(() {
                                          advancedRemoveButtons[function] =
                                              false;
                                        });
                                      }

                                      if (advancedRemoveButtons[function] ==
                                              false &&
                                          text.isNotEmpty) {
                                        setState(() {
                                          advancedRemoveButtons[function] =
                                              true;
                                        });
                                      }
                                    }

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: SearchBar(
                                        hintText: AppLocalizations.of(context)!
                                            .individualSearchHint(
                                                function.name),
                                        textInputAction: TextInputAction.search,
                                        controller:
                                            advancedSearchControllers[function],
                                        onSubmitted: filterFunction,
                                        onChanged: filterFunction,
                                        leading: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: advancedSearchIcons[function],
                                        ),
                                        trailing: [
                                          Visibility(
                                            visible: advancedRemoveButtons[
                                                function]!,
                                            child: IconButton(
                                                onPressed: () {
                                                  client.conversations.filter
                                                          .advancedSearch[
                                                      function] = "";
                                                  advancedSearchControllers[
                                                          function]!
                                                      .clear();
                                                  client.conversations.filter
                                                      .supply();

                                                  setState(() {
                                                    advancedRemoveButtons[
                                                        function] = false;
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
                                  hintText:
                                      AppLocalizations.of(context)!.searchHint,
                                  textInputAction: TextInputAction.search,
                                  controller: simpleSearchController,
                                  onSubmitted: (String text) {
                                    client.conversations.filter.simpleSearch =
                                        text;
                                    client.conversations.filter.supply();
                                  },
                                  onChanged: (String text) {
                                    client.conversations.filter.simpleSearch =
                                        text;
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
                                            client.conversations.filter
                                                .simpleSearch = "";
                                            simpleSearchController.clear();
                                            client.conversations.filter
                                                .supply();

                                            setState(() {
                                              simpleRemoveButton = false;
                                            });
                                          },
                                          icon: const Icon(Icons.delete)),
                                    ),
                                    MenuAnchor(
                                      builder: (context, controller, _) =>
                                          IconButton(
                                              onPressed: () {
                                                if (controller.isOpen) {
                                                  controller.close();
                                                } else {
                                                  controller.open();
                                                }
                                              },
                                              icon:
                                                  const Icon(Icons.more_vert)),
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
                                              ? AppLocalizations.of(context)!
                                                  .simpleSearch
                                              : AppLocalizations.of(context)!
                                                  .advancedSearch),
                                        ),
                                        MenuItemButton(
                                          leadingIcon: showHidden
                                              ? const Icon(Icons.visibility_off)
                                              : const Icon(Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              showHidden = !showHidden;
                                            });

                                            final oldEntries = client
                                                .fetchers
                                                .conversationsFetcher
                                                .stream
                                                .value
                                                .content;

                                            client.conversations.filter
                                                .showHidden = showHidden;
                                            client.conversations.filter
                                                .supply();

                                            if (!showHidden) {
                                              jumpToTopTile(
                                                  client
                                                      .fetchers
                                                      .conversationsFetcher
                                                      .stream
                                                      .value
                                                      .content!,
                                                  oldEntries!);
                                            } else {
                                              jumpToTopTile(
                                                  client
                                                      .fetchers
                                                      .conversationsFetcher
                                                      .stream
                                                      .value
                                                      .content!,
                                                  oldEntries!);
                                            }
                                          },
                                          child: Text(showHidden
                                              ? AppLocalizations.of(context)!
                                                  .showOnlyVisible
                                              : AppLocalizations.of(context)!
                                                  .showAll),
                                        ),
                                        const Divider(),
                                        MenuItemButton(
                                          leadingIcon: SizedBox.fromSize(
                                            size: Size(24, 0),
                                          ),
                                          onPressed: () {
                                            final oldEntries = client
                                                .fetchers
                                                .conversationsFetcher
                                                .stream
                                                .value
                                                .content;

                                            openToggleMode();

                                            jumpToTopTile(
                                                client
                                                    .fetchers
                                                    .conversationsFetcher
                                                    .stream
                                                    .value
                                                    .content!,
                                                oldEntries!);
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .hideShow),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ))
                        : SizedBox.shrink(),
              )),
          body: StreamBuilder(
              stream: fetcher.stream,
              builder: (context, snapshot) {
                if (snapshot.data?.status == FetcherStatus.error) {
                  return ErrorView(
                      error: snapshot.data!.error!,
                      name: AppLocalizations.of(context)!.messages,
                      retry: retryFetcher(fetcher));
                } else if (snapshot.data?.status == FetcherStatus.fetching ||
                    snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return RefreshIndicator(
                    key: _refreshKey,
                    onRefresh: () async {
                      fetcher.fetchData(forceRefresh: true);
                    },
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: (snapshot.data?.content!.length)! + 1,
                        itemExtentBuilder: (index, _) {
                          if (index > (snapshot.data?.content!.length)! - 1) {
                            return tileSize * 2.5;
                          }

                          return tileSize;
                        },
                        itemBuilder: (context, index) {
                          if (index > (snapshot.data?.content!.length)! - 1) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, left: 12.0, right: 12.0),
                              child: ListTile(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .noFurtherEntries,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                subtitle: Text(
                                  AppLocalizations.of(context)!
                                      .conversationNote,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }

                          return ConversationTile(
                            entry: snapshot.data!.content![index],
                            toggleMode: toggleMode,
                            checked: checkedTiles[
                                    snapshot.data!.content![index].id] ??
                                false,
                          );
                        }),
                  );
                }
              }),
          floatingActionButton: toggleMode
              ? FloatingActionButton.extended(
                  isExtended: !disableToggleButton,
                  icon: !disableToggleButton
                      ? Icon(Icons.visibility)
                      : SizedBox(
                          width: 24,
                          height: 24,
                          child: const CircularProgressIndicator(),
                        ),
                  label: Text(AppLocalizations.of(context)!.hideShow),
                  onPressed: !disableToggleButton
                      ? () async {
                          setState(() {
                            disableToggleButton = true;
                          });

                          // So you don't see each button being toggled
                          Map<String, bool> toggled = {};

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

                              toggled.addEntries([tile]);
                              checkedTiles[tile.key] = false;
                            }
                          }

                          for (final id in toggled.keys) {
                            client.conversations.filter
                                .toggleEntry(id, hidden: true);
                          }

                          client.conversations.filter.supply();
                          closeToggleMode();
                        }
                      : null)
              : FloatingActionButton(
                  onPressed: () async {
                    if (client.conversations.cachedCanChooseType != null) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        if (client.conversations.cachedCanChooseType!) {
                          return const TypeChooser();
                        }
                        return const CreateConversation(chatType: null);
                      }));
                      return;
                    }

                    setState(() {
                      loadingCreateButton = true;
                    });

                    bool canChooseType;
                    try {
                      canChooseType =
                          await client.conversations.canChooseType();
                    } on NoConnectionException {
                      setState(() {
                        loadingCreateButton = false;
                      });
                      return;
                    }

                    setState(() {
                      loadingCreateButton = false;
                    });

                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      if (canChooseType) {
                        return const TypeChooser();
                      }
                      return const CreateConversation(chatType: null);
                    }));
                  },
                  child: loadingCreateButton
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: const CircularProgressIndicator(),
                        )
                      : const Icon(Icons.edit),
                )),
    );
  }
}

class ConversationTile extends StatelessWidget {
  final OverviewEntry entry;
  final bool toggleMode;
  final bool checked;

  const ConversationTile(
      {super.key,
      required this.entry,
      required this.toggleMode,
      required this.checked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        margin: const EdgeInsets.all(0),
        color: entry.hidden
            ? Theme.of(context)
                .colorScheme
                .surfaceContainerLow
                .withOpacity(0.75)
            : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (entry.hidden) ...[
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
              smallSize: entry.unread ? 9 : 0,
              child: InkWell(
                onTap: () {
                  if (toggleMode) {
                    CheckTileNotification(id: entry.id).dispatch(context);
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        if (entry.unread == true) {
                          client.conversations.filter
                              .toggleEntry(entry.id, unread: true);
                          client.conversations.filter.supply();
                        }

                        return ConversationsChat.fromEntry(entry);
                      },
                    ),
                  );
                },
                onLongPress: () async {
                  // Try to let the tile be in same place as in the old list.
                  if (!toggleMode) {
                    final List<OverviewEntry> oldEntries = client
                        .fetchers.conversationsFetcher.stream.value.content!;
                    final oldPosition = oldEntries.indexOf(entry) * tileSize;

                    ToggleModeNotification().dispatch(context);
                    CheckTileNotification(id: entry.id).dispatch(context);

                    final List<OverviewEntry> entries = client
                        .fetchers.conversationsFetcher.stream.value.content!;

                    final index = entries.indexOf(entry);
                    final position = index * tileSize;
                    final offset =
                        Scrollable.of(context).deltaToScrollOrigin.dy;

                    final newOffset = position + (offset - oldPosition);
                    JumpToNotification(position: newOffset).dispatch(context);
                  }
                },
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Visibility(
                        visible: toggleMode,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Icon(
                            checked
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )),
                    Expanded(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                entry.title,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            if (entry.shortName != null) ...[
                              Flexible(
                                child: Text(
                                  entry.shortName!,
                                  overflow: TextOverflow.ellipsis,
                                  style: entry.shortName != null
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
                              entry.date,
                            ),
                            Text(
                              entry.fullName,
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
