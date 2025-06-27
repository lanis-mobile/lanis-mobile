import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sph_plan/generated/l10n.dart';
import 'package:sph_plan/applets/conversations/definition.dart';
import 'package:sph_plan/applets/conversations/parser.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';
import '../../../core/sph/sph.dart';
import '../../../models/client_status_exceptions.dart';
import '../../../models/conversations.dart';
import '../../../utils/keyboard_observer.dart';
import 'chat.dart';
import 'overview_dialogs.dart';

const double tileSize = 80.0;


class CheckTileNotification extends Notification {
  final String? id;

  const CheckTileNotification({this.id});
}

class JumpToNotification extends Notification {
  final double? position;

  const JumpToNotification({this.position});
}

class ConversationsView extends StatefulWidget {
  final Function? openDrawerCb;
  const ConversationsView({super.key, this.openDrawerCb });

  @override
  State<StatefulWidget> createState() => _ConversationsViewState();
}

class _ConversationsViewState extends State<ConversationsView> {
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

  OverviewFiltering get filter => sph!.parser.conversationsParser.filter;

  final TextEditingController simpleSearchController = TextEditingController();
  final Map<SearchFunction, TextEditingController> advancedSearchControllers = {
    SearchFunction.subject: TextEditingController(),
    SearchFunction.name: TextEditingController(),
    SearchFunction.schedule: TextEditingController()
  };
  final ScrollController scrollController = ScrollController();
  final KeyboardObserver keyboardObserver = KeyboardObserver();

  final Map<String, bool> checkedTiles = {};

  bool loadingCreateButton = false;
  bool disableToggleButton = false;

  Widget toggleModeAppBar() {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              constraints: BoxConstraints.tightFor(
                  width: kToolbarHeight, height: kToolbarHeight),
              onPressed: () {
                closeToggleMode();
                for (final tile in checkedTiles.keys) {
                  checkedTiles[tile] = false;
                }
              },
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              AppLocalizations.of(context).hideShowConversations,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 0, bottom: 8),
        child: Column(
          children: [
            // Advanced search
            if (advancedSearch) ...[
              ...List<Padding>.generate(filter.advancedSearch.length, (i) {
                SearchFunction function =
                    filter.advancedSearch.keys.elementAt(i);

                filterFunction(String text) {
                  filter.advancedSearch[function] = text;
                  filter.pushEntries();

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
                    hintText: AppLocalizations.of(context)
                        .individualSearchHint(function.name),
                    textInputAction: TextInputAction.search,
                    controller: advancedSearchControllers[function],
                    onSubmitted: filterFunction,
                    onChanged: filterFunction,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: advancedSearchIcons[function],
                    ),
                    trailing: [
                      Visibility(
                        visible: advancedRemoveButtons[function]!,
                        child: IconButton(
                            onPressed: () {
                              filter.advancedSearch[function] = "";
                              advancedSearchControllers[function]!.clear();
                              filter.pushEntries();

                              setState(() {
                                advancedRemoveButtons[function] = false;
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
              hintText: AppLocalizations.of(context).searchHint,
              textInputAction: TextInputAction.search,
              controller: simpleSearchController,
              onSubmitted: (String text) {
                filter.simpleSearch = text;
                filter.pushEntries();
              },
              onChanged: (String text) {
                filter.simpleSearch = text;
                filter.pushEntries();

                if (text.isEmpty) {
                  setState(() {
                    simpleRemoveButton = false;
                  });
                }

                if (simpleRemoveButton == false && text.isNotEmpty) {
                  setState(() {
                    simpleRemoveButton = true;
                  });
                }
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              trailing: [
                Visibility(
                  visible: simpleRemoveButton,
                  child: IconButton(
                      onPressed: () {
                        filter.simpleSearch = "";
                        simpleSearchController.clear();
                        filter.pushEntries();

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
                          ? AppLocalizations.of(context).simpleSearch
                          : AppLocalizations.of(context).advancedSearch),
                    ),
                    MenuItemButton(
                      leadingIcon: showHidden
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          showHidden = !showHidden;
                        });

                        final oldEntries = sph!.parser.conversationsParser.stream.value.content;

                        filter.showHidden = showHidden;
                        filter.pushEntries();

                        jumpToTopTile(
                            sph!.parser.conversationsParser.stream.value.content!, oldEntries!);

                      },
                      child: Text(showHidden
                          ? AppLocalizations.of(context).showOnlyVisible
                          : AppLocalizations.of(context).showAll),
                    ),
                    const Divider(),
                    MenuItemButton(
                      leadingIcon: SizedBox.fromSize(
                        size: Size(24, 0),
                      ),
                      onPressed: () {
                        final oldEntries = sph!.parser.conversationsParser.stream.value.content;

                        openToggleMode();

                        jumpToTopTile(
                            sph!.parser.conversationsParser.stream.value.content!, oldEntries!);
                      },
                      child: Text(AppLocalizations.of(context).hideShow),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  String? noConversationAsset;
  Widget sideBarNoConversationsLoaded() {
    final List<String> assets = [
      "assets/undraw/chat/undraw_work-chat_hc3y.svg",
      "assets/undraw/chat/undraw_quick-chat_3gj8.svg",
      "assets/undraw/chat/undraw_online-message_k64b.svg",
      "assets/undraw/chat/undraw_chatting_5u5z.svg",
      "assets/undraw/chat/undraw_chat_qmyo.svg",
    ];
    noConversationAsset ??= assets[(DateTime.now().millisecondsSinceEpoch / 1000).toInt() % assets.length];

    return Center(
      child: SvgPicture.asset(noConversationAsset!,
          height: 175.0),
    );
  }

  // Switching between two lists of overview entries messes up the scroll controller, so we just try to jump to the top visible tile and anchor to it.
  // If top tile is not visible in the new list, we try to find the first visible tile above the top tile and jump to it.
  void jumpToTopTile(
      final List<OverviewEntry> entries, final List<OverviewEntry> oldEntries) {
    if (oldEntries.isEmpty) return;

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
      scrollController.jumpTo(size - viewport + 64);
    } else {
      scrollController.jumpTo(
          position + (scrollController.offset - (offsetTopIndex * tileSize)));
    }
  }

  void openToggleMode() {
    setState(() {
      toggleMode = true;
    });
    filter.toggleMode = true;
    filter.pushEntries();
    sph!.parser.conversationsParser.toggleSuspend();
  }

  void closeToggleMode() {
    setState(() {
      toggleMode = false;
      disableToggleButton = false;
    });

    final oldEntries = sph!.parser.conversationsParser.stream.value.content;

    filter.toggleMode = false;
    filter.pushEntries();

    sph!.parser.conversationsParser.toggleSuspend();

    jumpToTopTile(sph!.parser.conversationsParser.stream.value.content!, oldEntries!);
  }

  @override
  void initState() {
    super.initState();

    sph!.parser.conversationsParser.fetchData();

    keyboardObserver.addDefaultCallback();

    simpleSearchController.text = filter.simpleSearch;

    for (final value in SearchFunction.values) {
      advancedSearchControllers[value]!.text =
          filter.advancedSearch[value] ?? "";
    }
  }

  @override
  void dispose() {
    super.dispose();

    simpleSearchController.dispose();
    for (final value in SearchFunction.values) {
      advancedSearchControllers[value]!.dispose();
    }

    keyboardObserver.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.openDrawerCb != null ? AppBar(
        title: Text(conversationsDefinition.label(context)),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => widget.openDrawerCb!(),
        ),
      ) : null,
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is CheckTileNotification) {
            if (!toggleMode) {
              openToggleMode();
            }

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
        child: Row(
          children: [
            Expanded(
                child: Scaffold(
                body: CombinedAppletBuilder<List<OverviewEntry>>(
                    parser: sph!.parser.conversationsParser,
                    phpUrl: conversationsDefinition.appletPhpUrl,
                    settingsDefaults: conversationsDefinition.settingsDefaults,
                    accountType: sph!.session.accountType,
                    builder: (context, data, accountType, settings, updateSetting, refresh) {
                      return RefreshIndicator(
                          key: _refreshKey,
                          edgeOffset: advancedSearch && !toggleMode ? 256 : 64,
                          onRefresh: refresh!,
                          child: CustomScrollView(
                            controller: scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverFloatingHeader(
                                child: toggleMode
                                    ? toggleModeAppBar()
                                    : searchWidget(),
                              ),
                              SliverVariedExtentList.builder(
                                itemCount: data.length + 1,
                                itemExtentBuilder: (index, _) {
                                  if (index > data.length - 1) {
                                    return tileSize * 2.5;
                                  }

                                  return tileSize;
                                },
                                itemBuilder: (context, index) {
                                  if (index > data.length - 1) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, left: 12.0, right: 12.0),
                                      child: ListTile(
                                        title: Text(
                                          AppLocalizations.of(context)
                                              .noFurtherEntries,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        subtitle: Text(
                                          AppLocalizations.of(context)
                                              .conversationNote,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }

                                  return ConversationTile(
                                    entry: data[index],
                                    toggleMode: toggleMode,
                                    checked: checkedTiles[data[index].id] ??
                                        false,
                                  );
                                },
                              )
                            ],
                          ));
                    }),
                floatingActionButton: toggleMode
                    ? disableToggleButton
                    ? FloatingActionButton(
                    onPressed: null,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: const CircularProgressIndicator(),
                    ))
                    : FloatingActionButton.extended(
                    icon: Icon(Icons.visibility),
                    label: Text(AppLocalizations.of(context).hideShow),
                    onPressed: () async {
                      setState(() {
                        disableToggleButton = true;
                      });

                      // So you don't see each tile being toggled
                      Map<String, bool> toggled = {};

                      for (final tile in checkedTiles.entries) {
                        if (tile.value == true) {
                          final isHidden = filter.entries
                              .where((element) => element.id == tile.key)
                              .first
                              .hidden;

                          late bool result;
                          try {
                            if (isHidden) {
                              result = await sph!.parser.conversationsParser
                                  .showConversation(tile.key);
                            } else {
                              result = await sph!.parser.conversationsParser
                                  .hideConversation(tile.key);
                            }
                          } on NoConnectionException {
                            setState(() {
                              disableToggleButton = false;
                            });

                            if(context.mounted) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    icon: const Icon(Icons.wifi_off),
                                    title: Text(
                                        AppLocalizations.of(context)
                                            .noInternetConnection2),
                                    actions: [
                                      FilledButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .back))
                                    ],
                                  ));
                            }
                            return;
                          }

                          if (!result) {
                            setState(() {
                              disableToggleButton = false;
                            });

                            if(context.mounted) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    icon: const Icon(Icons.error),
                                    title: Text(
                                        AppLocalizations.of(context)
                                            .errorOccurred),
                                    actions: [
                                      FilledButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .back))
                                    ],
                                  ));
                            }
                            return;
                          }

                          toggled.addEntries([tile]);
                          checkedTiles[tile.key] = false;
                        }
                      }

                      for (final id in toggled.keys) {
                        filter.toggleEntry(id, hidden: true);
                      }

                      filter.pushEntries();
                      closeToggleMode();
                    })
                    : FloatingActionButton(
                  onPressed: () async {
                    if (sph!.parser.conversationsParser.cachedCanChooseType != null) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        if (sph!.parser.conversationsParser.cachedCanChooseType!) {
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
                      await sph!.parser.conversationsParser.canChooseType();
                    } on NoConnectionException {
                      setState(() {
                        loadingCreateButton = false;
                      });
                      return;
                    }

                    setState(() {
                      loadingCreateButton = false;
                    });

                    if(context.mounted) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        if (canChooseType) {
                          return const TypeChooser();
                        }
                        return const CreateConversation(chatType: null);
                      }));
                    }
                  },
                  child: loadingCreateButton
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: const CircularProgressIndicator(),
                  )
                      : const Icon(Icons.edit),
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: 1,
              color: Theme.of(context).colorScheme.outline,
            ),
            Expanded(
              flex: 2,
              child: sideBarNoConversationsLoaded(),
            )
          ],
        ),
      ),
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
                .withValues(alpha: 0.8)
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
                              .onSurfaceVariant
                              .withValues(alpha: 0.05)
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerLow
                              .withValues(alpha: 0.8),
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
                          sph!.parser.conversationsParser.filter
                              .toggleEntry(entry.id, unread: true);
                          sph!.parser.conversationsParser.filter.pushEntries();
                        }

                        return ConversationsChat.fromEntry(entry);
                      },
                    ),
                  );
                },
                onLongPress: () async {
                  // Try to let the tile be in same place as in the old list.
                  if (!toggleMode) {
                    final List<OverviewEntry> oldEntries = sph!.parser.conversationsParser.stream.value.content!;
                    final oldPosition = oldEntries.indexOf(entry) * tileSize;

                    CheckTileNotification(id: entry.id).dispatch(context);

                    final List<OverviewEntry> entries = sph!.parser.conversationsParser.stream.value.content!;

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
