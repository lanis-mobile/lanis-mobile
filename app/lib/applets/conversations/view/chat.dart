import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/generated/l10n.dart';
import 'package:sph_plan/applets/conversations/view/send.dart';
import 'dart:async';

import '../../../core/sph/sph.dart';
import '../../../models/client_status_exceptions.dart';
import '../../../models/conversations.dart';
import '../../../utils/fetch_more_indicator.dart';
import '../../../utils/logger.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/format_text.dart';
import 'shared.dart';

class ConversationsChat extends StatefulWidget {
  final String id;
  final String title;
  final NewConversationSettings? newSettings;
  final bool hidden;
  final bool isTablet;
  final Function refreshSidebar;

  const ConversationsChat(
      {super.key, required this.title, required this.id, this.newSettings, required this.isTablet, required this.refreshSidebar,
        this.hidden = false});

  ConversationsChat.fromEntry(OverviewEntry entry, this.isTablet, {super.key, required this.refreshSidebar})
      : id = entry.id
      , title = entry.title
      , newSettings = null
      , hidden = entry.hidden;
  @override
  State<ConversationsChat> createState() => _ConversationsChatState();
}

class _ConversationsChatState extends State<ConversationsChat>
    with SingleTickerProviderStateMixin {
  late final Future<void> _conversationFuture = initConversation();
  late final AnimationController appBarController;
  Timer? _refreshTimer;
  int _lastRefresh = 0;
  final List<String> _messagesSendInThisSession = [];

  final TextEditingController messageField = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final ValueNotifier<bool> isSendVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isScrollToBottomVisible = ValueNotifier<bool>(false);
  final TextEditingController textEditingController = TextEditingController();

  final IndicatorController refreshIndicatorController = IndicatorController();


  final Map<String, TextStyle> textStyles = {};

  late ConversationSettings settings;
  late ParticipationStatistics? statistics;

  late bool hidden;
  bool refreshing = false;

  final List<dynamic> chat = [];

  void initRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      if (mounted) {
        setState(() {
          refreshing = true;
        });
        await refreshConversation(scrollToEnd: false);
        setState(() {
          refreshing = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    appBarController = AnimationController(vsync: this);
    scrollController.addListener(animateAppBarTitle);
    scrollController.addListener(toggleScrollToBottomFab);
    hidden = widget.hidden;

    // Initialize periodic refresh timer (every 1 minute)
    initRefreshTimer();
  }

  @override
  void dispose() {
    super.dispose();
    appBarController.dispose();
    scrollController.dispose();
    _refreshTimer?.cancel();
  }

  void toggleScrollToBottomFab() {
    final maxScrollExtent = scrollController.position.maxScrollExtent;
    final currentScrollPosition = scrollController.position.pixels;

    isScrollToBottomVisible.value = currentScrollPosition < maxScrollExtent - 100;
  }
  Future<void> refreshConversation({bool scrollToEnd = true}) async {
    if (widget.newSettings == null) {
      try {
        final result = await sph!.parser.conversationsParser.refreshConversation(widget.id, _lastRefresh);

        _lastRefresh = result.lastRefresh;
        for (final UnparsedMessage message in result.messages) {
          if (_messagesSendInThisSession.contains(message.id)) {
            continue;
          }
          setState(() {
            _renderSingleMessage(message);
          });
        }
        if (result.messages.isNotEmpty) {
          widget.refreshSidebar();
        }

        // Update send button visibility
        if (settings.own) {
          isSendVisible.value = true;
        } else {
          isSendVisible.value = !settings.noReply;
        }

        // Scroll to bottom after refresh
        if (scrollToEnd) scrollToBottom();
      } on NoConnectionException {
        showNoInternetDialog();
      } catch (e) {
        showErrorDialog();
      }
    }
  }

  void animateAppBarTitle() {
    const appBarHeight = 56.0;

    if (scrollController.offset >= appBarHeight &&
        appBarController.value == 0) {
      appBarController.value = 1;
    } else if (scrollController.offset == 0 && appBarController.value == 1) {
      appBarController.reverse();
    }
  }

  void scrollToBottom({Duration initDelay = Duration.zero}) {
    logger.d("Scrolling to bottom");
      Future.delayed(initDelay, () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 10,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
  }

  void showErrorDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.error),
          title: Text(AppLocalizations.of(context).errorOccurred),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context).back)
            )
          ],
        )
    );
  }

  void showNoInternetDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.wifi_off),
          title: Text(AppLocalizations.of(context).noInternetConnection2),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context).back)
            )
          ],
        )
    );
  }

  static DateTime parseDateString(String date) {
    if (date.contains("heute")) {
      DateTime now = DateTime.now();
      DateTime conversation = DateFormat("H:m").parse(date.substring(6));

      return now.copyWith(
          hour: conversation.hour, minute: conversation.minute, second: 0);
    } else if (date.contains("gestern")) {
      DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
      DateTime conversation = DateFormat("H:m").parse(date.substring(8));

      return yesterday.copyWith(
          hour: conversation.hour, minute: conversation.minute, second: 0);
    } else {
      return DateFormat("d.M.y H:m").parse(date);
    }
  }

  void addAuthorTextStyles(final List<String> authors) {
    final ThemeData theme = Theme.of(context);
    for (final String author in authors) {
      textStyles[author] = BubbleStyle.getAuthorTextStyle(theme, author);
    }
  }

  Future<void> sendMessage(String text) async {
    MessageState state = MessageState.first;
    if (chat.last is Message) {
      DateTime date = chat.last.date;
      if (date.isToday) {
        state = MessageState.series;
      }
    }

    final textMessage = Message(
      text: text,
      own: true,
      date: DateTime.now(),
      author: null,
      state: state,
      status: MessageStatus.sending,
    );

    setState(() {
      DateTime lastMessageDate = chat.last.date;
      if (lastMessageDate.isToday) {
        chat.add(textMessage);
      } else {
        chat.addAll([DateHeader(date: DateTime.now()), textMessage]);
      }
    });

    final result = await sph!.parser.conversationsParser.replyToConversation(
        settings.id,
        "all",
        settings.groupChat ? "ja" : "nein",
        settings.onlyPrivateAnswers ? "ja" : "nein",
        text);

    widget.refreshSidebar();
    setState(() {
      if (result.success) {
        _messagesSendInThisSession.add(result.messageId);
        chat.last.status = MessageStatus.sent;
      } else {
        chat.last.status = MessageStatus.error;
        showSnackbar(
            context, AppLocalizations.of(context).errorSendingMessage);
      }
    });
  }

  Message addMessage(UnparsedMessage message, MessageState position) {
    final contentParsed = parse(message.content);
    final content = contentParsed.body!.text;

    return Message(
      text: content,
      own: message.own,
      author: message.author,
      date: parseDateString(message.date),
      state: position,
      status: MessageStatus.sent,
    );
  }

  List<String> authors = [];

void _renderSingleMessage(UnparsedMessage message) {
  final DateTime messageDate = parseDateString(message.date);
  final String messageAuthor = message.author;
  MessageState position = MessageState.first;

  // Check if this message should be part of a series by examining the last message in chat
  if (chat.isNotEmpty && chat.last is Message) {
    Message lastMessage = chat.last;
    if (messageAuthor == lastMessage.author &&
        messageDate.isSameDay(lastMessage.date)) {
      position = MessageState.series;
    }
  }

  // Add message to appropriate authors list for styling
  if (message.own != true) {
    authors.add(messageAuthor);
  }

  // Add message to chat with appropriate date header if needed
  if (chat.isEmpty || (chat.last is Message && !messageDate.isSameDay(chat.last.date))) {
    chat.addAll([DateHeader(date: messageDate), addMessage(message, position)]);
  } else {
    chat.add(addMessage(message, position));
  }
}

void renderMessages(Conversation unparsedMessages) {
  chat.clear(); // Clear existing messages for refresh capability
  authors.clear(); // Clear existing authors

  // Process parent message
  final DateTime parentDate = parseDateString(unparsedMessages.parent.date);
  final String parentAuthor = unparsedMessages.parent.author;

  if (unparsedMessages.parent.own != true) {
    authors.add(parentAuthor);
  }

  // Add parent message with initial date header
  chat.addAll([
    DateHeader(date: parentDate),
    addMessage(unparsedMessages.parent, MessageState.first)
  ]);

  // Process all replies
  for (UnparsedMessage reply in unparsedMessages.replies) {
    _renderSingleMessage(reply);
  }

  addAuthorTextStyles(authors.toList());
}
  Future<void> initConversation() async {
    if (widget.newSettings == null) {
      Conversation result =
          await sph!.parser.conversationsParser.getSingleConversation(widget.id);
      _lastRefresh = result.msgLastRefresh;
      logger.d("last refresh: $_lastRefresh");

      settings = ConversationSettings(
        id: widget.id,
        groupChat: result.groupChat,
        onlyPrivateAnswers: result.onlyPrivateAnswers,
        noReply: result.noReply,
        author: result.parent.author,
        own: result.parent.own,
      );

      statistics = ParticipationStatistics(
          countParents: result.countParents,
          countStudents: result.countStudents,
          countTeachers: result.countTeachers,
          knownParticipants: result.knownParticipants);

      renderMessages(result);
    } else {
      settings = widget.newSettings!.settings;

      statistics = null;

      chat.addAll([
        DateHeader(date: widget.newSettings!.firstMessage.date),
        widget.newSettings!.firstMessage
      ]);
    }

    if (settings.own) {
      isSendVisible.value = true;
    } else {
      isSendVisible.value = !settings.noReply;
    }
  }

  Future<void> openSendPage(BuildContext context) async {
  final result = await Navigator.of(context).push(MaterialPageRoute(
  builder: (context) => ConversationsSend(isTablet: widget.isTablet, title: widget.title,)));

  if (result == null) return;

  scrollController.jumpTo(scrollController.position.maxScrollExtent);

  await sendMessage(result);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ValueListenableBuilder(
        valueListenable: isScrollToBottomVisible,
        builder: (context, isVisible, _) {
          return Visibility(
            visible: isVisible,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60,),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondaryFixedDim,
                      width: 1.5,
                    ),
                    color: Theme.of(context).colorScheme.surfaceDim
                  ),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
          );
        },
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _conversationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              // Error content
              if (snapshot.hasError) {
                if (snapshot.error is LanisException) {
                  return ErrorView(
                    error: snapshot.error as LanisException,
                    showAppBar: true,
                    retry: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => ConversationsChat(
                            refreshSidebar: widget.refreshSidebar,
                            title: widget.title,
                            id: widget.id,
                            newSettings: widget.newSettings,
                            isTablet: widget.isTablet,
                          ))
                      );
                    },
                  );
                }
              }

              scrollToBottom(initDelay: Duration(milliseconds: 100));
              return Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollMetricsNotification>(
                      onNotification: (_) {
                        toggleScrollToBottomFab();
                        return false;
                      },
                      child: FetchMoreIndicator(
                        controller: refreshIndicatorController,
                        onAction: refreshConversation,
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverAppBar(
                              title: Animate(
                                effects: const [
                                  FadeEffect(
                                    curve: Curves.easeIn,
                                  )
                                ],
                                value: 0,
                                autoPlay: false,
                                controller: appBarController,
                                child: Text(widget.title),
                              ),
                              snap: true,
                              floating: true,
                              actions: [
                                if (refreshing) Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                if (settings.groupChat == false &&
                                    settings.onlyPrivateAnswers == false &&
                                    settings.noReply == false) ...[
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            icon: const Icon(Icons.groups),
                                            title: Text(
                                                AppLocalizations.of(context)
                                                    .conversationTypeName(
                                                    ChatType.openChat.name)),
                                            content: Text(
                                                AppLocalizations.of(context)
                                                    .openChatWarning),
                                            actions: [
                                              FilledButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Ok"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.warning),
                                  ),
                                ],
                                if (!widget.isTablet) IconButton(
                                    onPressed: () async {
                                      if (hidden == true) {
                                        bool result;
                                        try {
                                          result = await sph!.parser.conversationsParser.showConversation(widget.id);
                                        } on NoConnectionException {
                                          showNoInternetDialog();
                                          return;
                                        }
                        
                        
                                        if (!result) {
                                          showErrorDialog();
                                          return;
                                        } else {
                                          setState(() {
                                            hidden = false;
                                          });
                                          sph!.parser.conversationsParser.filter.toggleEntry(widget.id, hidden: true);
                                          sph!.parser.conversationsParser.filter.pushEntries();
                                        }
                        
                                        return;
                                      }
                        
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            icon: const Icon(Icons.visibility_off),
                                            title: Text(AppLocalizations.of(context).conversationHide),
                                            content: Text(AppLocalizations.of(context).hideNote),
                                            actions: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(AppLocalizations.of(context).back)
                                              ),
                                              FilledButton(
                                                  onPressed: () async {
                                                    bool result = false;
                                                    try {
                                                      result = await sph!.parser.conversationsParser.hideConversation(widget.id);
                                                    } on NoConnectionException {
                                                      showNoInternetDialog();
                                                      return;
                                                    }
                        
                                                    if (!result) {
                                                      showErrorDialog();
                                                      return;
                                                    } else {
                                                      setState(() {
                                                        hidden = true;
                                                      });
                                                      sph!.parser.conversationsParser.filter.toggleEntry(widget.id, hidden: true);
                                                    }
                        
                                                    if(context.mounted) Navigator.of(context).pop();
                                                  },
                                                  child: Text(AppLocalizations.of(context).conversationHide)
                                              )
                                            ],
                                          )
                                      );
                                    },
                                    icon: hidden ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)
                                ),
                                if (statistics != null) ...[
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => StatisticWidget(
                                              statistics: statistics!,
                                              conversationTitle: widget.title),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.people),
                                  ),
                                ],
                              ],

                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Text(
                                              widget.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (settings.onlyPrivateAnswers && !settings.own) ...[
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 12.0),
                                        margin: const EdgeInsets.only(top: 16.0),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHigh),
                                        child: Text(
                                          "${settings.author} ${AppLocalizations.of(context).privateConversation}",
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            SliverList.builder(
                              itemCount: chat.length,
                              itemBuilder: (context, index) {
                                if (chat[index] is Message) {
                                  return MessageWidget(
                                      message: chat[index],
                                      textStyle: textStyles[chat[index].author]);
                                } else {
                                  return DateHeaderWidget(header: chat[index]);
                                }
                              },
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                            onPressed: () => openSendPage(context),
                            icon: Icon(Icons.expand,),
                            color: Theme.of(context).colorScheme.onSecondary,
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .sendMessagePlaceholder,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                            onPressed: () async {
                              final String text = textEditingController.text.trim();
                              if (text.isEmpty) return;

                              textEditingController.clear();
                              await sendMessage(text);
                              scrollToBottom();
                            },
                            icon: Icon(Icons.send,),
                            color: Theme.of(context).colorScheme.onTertiary,
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
            // Waiting content
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class StatisticWidget extends StatelessWidget {
  final String conversationTitle;
  final ParticipationStatistics statistics;

  const StatisticWidget(
      {super.key, required this.statistics, required this.conversationTitle});

  Widget statisticsHeaderRow(BuildContext context, Icon icon, String title, int count) {
    return Column(
      children: [
        icon,
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).receivers),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 30,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.groups_outlined, size: 60,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  conversationTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30,),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: statisticsHeaderRow(context, const Icon(Icons.person), AppLocalizations.of(context).participants, statistics.countStudents)),
                  Expanded(child: statisticsHeaderRow(context, const Icon(Icons.school), AppLocalizations.of(context).supervisors, statistics.countTeachers)),
                  Expanded(child: statisticsHeaderRow(context, const Icon(Icons.supervisor_account), AppLocalizations.of(context).parents, statistics.countParents)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15,),
          Text(
              AppLocalizations.of(context).knownReceivers,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5,),
          for (final KnownParticipant participant in statistics.knownParticipants) ...[
            ListTile(
              title: Text(participant.name),
              leading: Icon(participant.type.icon),
            )
          ]
        ],
      ),
    );
  }
}

class DateHeaderWidget extends StatelessWidget {
  final DateHeader header;

  const DateHeaderWidget({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: const EdgeInsets.only(top: 16.0, bottom: 4.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(DateFormat(
                    "d. MMMM y", Localizations.localeOf(context).languageCode)
                .format(header.date)),
          ),
        )
      ],
    );
  }
}

class MessageWidget extends StatefulWidget {
  final Message message;
  final TextStyle? textStyle;

  const MessageWidget(
      {super.key, required this.message, required this.textStyle});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> tapped = ValueNotifier(false);
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.sizeOf(context).width - 200;

    return Padding(
      padding: BubbleStructure.getMargin(widget.message.state),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: BubbleStructure.getAlignment(widget.message.own),
        children: [
          // Author name
          if (widget.message.state == MessageState.first &&
              !widget.message.own) ...[
            Text(
              widget.message.author!,
              style: widget.textStyle,
            )
          ],

          // Message bubble
          ClipPath(
            clipper: widget.message.state == MessageState.first
                ? BubbleStructure.getFirstStateClipper(widget.message.own)
                : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.clamp(350, 600),
              ),
              child: GestureDetector(
                onLongPress: () async {
                  tapped.value = false;
                  HapticFeedback.vibrate();
                  await Clipboard.setData(
                      ClipboardData(text: widget.message.text));
                  if(context.mounted) {
                    showSnackbar(
                      context, AppLocalizations.of(context).copiedMessage);
                  }
                  controller.value = 0;
                  controller.forward();
                },
                onTapDown: (_) async {
                  await Future.delayed(const Duration(milliseconds: 50));
                  tapped.value = true;
                },
                onTapUp: (_) async {
                  await Future.delayed(const Duration(milliseconds: 150));
                  tapped.value = false;
                },
                onTapCancel: () async {
                  setState(() {
                    tapped.value = false;
                  });
                },
                child: Animate(
                  autoPlay: false,
                  effects: const [
                    ShimmerEffect(
                      duration: Duration(milliseconds: 600),
                    )
                  ],
                  controller: controller,
                  child: ValueListenableBuilder(
                      valueListenable: tapped,
                      builder: (context, isTapped, _) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: isTapped
                                ? BubbleStyles.getStyle(widget.message.own)
                                    .pressedColor
                                : BubbleStyles.getStyle(widget.message.own)
                                    .mainColor,
                            borderRadius:
                                widget.message.state != MessageState.first
                                    ? BubbleStructure.radius
                                    : null,
                          ),
                          child: Padding(
                              padding: BubbleStructure.getPadding(
                                  widget.message.state == MessageState.first,
                                  widget.message.own),
                              child: FormattedText(
                                  text: widget.message.text,
                                  formatStyle:
                                      BubbleStyles.getStyle(widget.message.own)
                                          .textFormatStyle)),
                        );
                      }),
                ),
              ),
            ),
          ),

          // Date text
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.message.state == MessageState.first
                      ? BubbleStructure.compensatedPadding
                      : BubbleStructure.horizontalPadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(DateFormat("HH:mm").format(widget.message.date),
                      style: BubbleStyles.getStyle(widget.message.own)
                          .dateTextStyle),
                  if (widget.message.own) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Icon(
                        Icons.circle,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 3,
                      ),
                    ),
                    if (widget.message.status == MessageStatus.sending) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: SizedBox(
                            width: 10.0,
                            height: 10.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                            )),
                      )
                    ] else if (widget.message.status ==
                        MessageStatus.error) ...[
                      Icon(
                        Icons.error,
                        color: Theme.of(context).colorScheme.error,
                        size: 12,
                      )
                    ] else ...[
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 12,
                      )
                    ]
                  ]
                ],
              ))
        ],
      ),
    );
  }
}
