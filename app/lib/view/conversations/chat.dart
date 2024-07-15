import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/shared/widgets/format_text.dart';
import 'package:sph_plan/view/conversations/send.dart';

import '../../client/client.dart';
import '../../shared/exceptions/client_status_exceptions.dart';
import '../../shared/widgets/error_view.dart';
import 'shared.dart';

class ConversationsChat extends StatefulWidget {
  final String id; // uniqueId
  final String title;
  final NewConversationSettings? newSettings;

  const ConversationsChat({super.key, required this.title, required this.id, this.newSettings});

  @override
  State<ConversationsChat> createState() => _ConversationsChatState();
}

class _ConversationsChatState extends State<ConversationsChat> with TickerProviderStateMixin {
  late final Future<dynamic> _conversationFuture = initConversation();
  late final AnimationController appBarController;

  final TextEditingController messageField = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final ValueNotifier<bool> isSendVisible = ValueNotifier<bool>(false);

  final Map<String, TextStyle> textStyles = {};

  late final ConversationSettings settings;

  final List<dynamic> chat = [];

  @override
  void initState() {
    // Make the app bar title disappear when scrolled to the top
    appBarController = AnimationController(vsync: this);
    scrollController.addListener(animateAppBarTitle);
    animateAppBarTitle();

    super.initState();
  }

  animateAppBarTitle() {
    if (!scrollController.hasClients) return;

    const appBarHeight = 56.0;

    if (scrollController.offset >= appBarHeight && appBarController.value == 0) {
      appBarController.value = 1;
    } else if (scrollController.offset == 0 && appBarController.value == 1) {
      appBarController.reverse();
    }
  }

  static DateTime parseDateString(String date) {
    if (date.contains("heute")) {
      DateTime now = DateTime.now();
      DateTime conversation = DateFormat("H:m").parse(date.substring(6));

      return now.copyWith(hour: conversation.hour, minute: conversation.minute, second: 0);
    } else if (date.contains("gestern")) {
      DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
      DateTime conversation = DateFormat("H:m").parse(date.substring(8));

      return yesterday.copyWith(hour: conversation.hour, minute: conversation.minute, second: 0);
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

  Future<void> sendMessage(String text, {bool? offline, bool? success, bool? other}) async {
    final textMessage = Message(
        text: text,
        own: other == true && kDebugMode ? false : true,
        date: DateTime.now(),
        author: other == true && kDebugMode ? "Debug Person" : null,
        state: MessageState.first,
        status: MessageStatus.sending,
    );

    setState(() {
      DateTime lastMessageDate = chat.last.date;
      if (lastMessageDate.isToday) {
        chat.add(textMessage);
      } else {
        chat.addAll([
          DateHeader(date: DateTime.now()),
          textMessage
        ]);
      }
    });

    late final bool result;
    if (kDebugMode && offline == true) {
      result = success!;
    } else {
      result = await client.conversations.replyToConversation(
          settings.id,
          "all",
          settings.groupChat ? "ja" : "nein",
          settings.onlyPrivateAnswers ? "ja" : "nein",
          text
      );
    }

    setState(() {
      if (result) {
        chat.last.status = MessageStatus.sent;
      } else {
        chat.last.status = MessageStatus.error;
      }
    });
  }

  Message addMessage(dynamic message, MessageState position) {
    final contentParsed = parse(message["Inhalt"]);
    final content = contentParsed.body!.text;

    return Message(
      text: content,
      own: message["own"],
      author: message["username"],
      date: parseDateString(message["Datum"]),
      state: position,
      status: MessageStatus.sent,
    );
  }

  void parseMessages(dynamic unparsedMessages) {
    DateTime date = parseDateString(unparsedMessages["Datum"]);
    String author = unparsedMessages["username"];
    MessageState position = MessageState.first;

    final Set<String> authors = {};

    if (unparsedMessages["own"] != true) {
      authors.add(author);
    }

    chat.addAll([
      DateHeader(date: date),
      addMessage(unparsedMessages, position)
    ]);

    late DateTime currentDate;
    for (dynamic current in unparsedMessages["reply"]) {
      currentDate = parseDateString(current["Datum"]);

      position = MessageState.first;
      if (current["username"] == author) {
        if (date.isSameDay(currentDate)) {
          position = MessageState.series;
        }
      }

      if (date.isSameDay(currentDate) && current["username"] == author) {
        chat.add(addMessage(current, position));
      } else if (date.isSameDay(currentDate) && current["username"] != author) {
        author = current["username"];
        chat.addAll([
          addMessage(current, position)
        ]);
      } else if (!date.isSameDay(currentDate) && current["username"] == author) {
        date = currentDate;
        chat.addAll([
          DateHeader(date: date),
          addMessage(current, position)
        ]);
      } else {
        date = currentDate;
        author = current["username"];
        chat.addAll([
          DateHeader(date: date),
          addMessage(current, position)
        ]);
      }

      if (current["own"] != true) {
        authors.add(author);
      }
    }

    addAuthorTextStyles(authors.toList());
  }

  Future<void> initConversation() async {
    if (widget.newSettings == null) {
      dynamic response = await client.conversations.getSingleConversation(widget.id);

      /*if (privateAnswerOnly == "ja" && response["own"] == false) {
        replyReceiver = response["username"];
      } else {
        replyReceiver = null;
      }*/

      settings = ConversationSettings(
          id: widget.id,
          groupChat: response["groupOnly"] == "ja",
          onlyPrivateAnswers: response["privateAnswerOnly"] == "ja",
          noReply: response["noAnswerAllowed"] == "ja" ? true : false,
          author: response["username"],
          own: response["own"]
      );

      parseMessages(response);
    } else {
      settings = widget.newSettings!.settings;

      chat.addAll([
        DateHeader(date: widget.newSettings!.firstMessage.date),
        widget.newSettings!.firstMessage
      ]);
    }

    isSendVisible.value = !settings.noReply;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ValueListenableBuilder(
          valueListenable: isSendVisible,
          builder: (context, isVisible, _) {
            return Visibility(
              visible: isVisible,
              child: FloatingActionButton.extended(
                label: const Text("Neue Nachricht"),
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConversationsSend()));
              
                  if (kDebugMode && result is List) {
                    await sendMessage(result[0], offline: true, success: result[1], other: result[2]);
                  } else if (result is String) {
                    await sendMessage(result);
                  }
                },
              ),
            );
          }
      ),
      body: FutureBuilder(
          future: _conversationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              // Error content
              if (snapshot.hasError) {
                if (snapshot.error is LanisException) {
                  return ErrorView(
                    data: snapshot.error as LanisException,
                    name: "einer einzelnen Nachricht",
                    fetcher: null,
                  );
                }
              }

              return CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    title: Animate(
                      effects: const [FadeEffect(
                          curve: Curves.easeIn,
                      )],
                      value: 0,
                      autoPlay: false,
                      controller: appBarController,
                      child: Text(widget.title),
                    ),
                    snap: true,
                    floating: true,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    widget.title,
                                    style: Theme.of(context).textTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (settings.onlyPrivateAnswers && !settings.own) ...[
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              margin: const EdgeInsets.only(top: 16.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHigh
                              ),
                              child: Text(
                                "${settings.author} kann nur deine Nachrichten sehen!",
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: chat.length,
                    itemBuilder: (context, index) {
                      if (chat[index] is Message) {
                        return MessageWidget(message: chat[index], textStyle: textStyles[chat[index].author]);
                        //return MessageBuilder(chat[index]);
                      } else {
                        return DateHeaderWidget(header: chat[index]);
                      }
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 75,
                    ),
                  )
                ],
              );
            }
            // Waiting content
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      )
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(DateFormat("d. MMMM y", Localizations.localeOf(context).languageCode).format(header.date)),
          ),
        )
      ],
    );
  }
}


class MessageWidget extends StatefulWidget {
  final Message message;
  final TextStyle? textStyle;
  const MessageWidget({super.key, required this.message, required this.textStyle});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> with SingleTickerProviderStateMixin {
  ValueNotifier<bool> tapped = ValueNotifier(false);
  late final AnimationController controller;



  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: BubbleStructure.getMargin(widget.message.state),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: BubbleStructure.getAlignment(widget.message.own),
        children: [
          // Author name
          if (widget.message.state == MessageState.first && !widget.message.own) ...[
            Text(
              widget.message.author!,
              style: widget.textStyle,
            )
          ],

          // Message bubble
          ClipPath(
            clipper: widget.message.state == MessageState.first ? BubbleStructure.getFirstStateClipper(widget.message.own) : null,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 350, //TODO: MAKE IT DYNAMIC TO SCREEN
              ),
              child: GestureDetector(
                onLongPress: () async {
                  tapped.value = false;
                  HapticFeedback.vibrate();
                  await Clipboard.setData(ClipboardData(text: widget.message.text));
                  showSnackbar(context, "Nachricht wurde kopiert!");
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
                  effects: const [ShimmerEffect(
                      duration: Duration(milliseconds: 600),
                  )],
                  controller: controller,
                  child: ValueListenableBuilder(
                      valueListenable: tapped,
                      builder: (context, isTapped, _) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                              color: isTapped ? BubbleStyles.getStyle(widget.message.own).pressedColor : BubbleStyles.getStyle(widget.message.own).mainColor,
                              borderRadius: widget.message.state != MessageState.first ? BubbleStructure.radius : null,
                          ),
                          child: Padding(
                              padding: BubbleStructure.getPadding(widget.message.state == MessageState.first, widget.message.own),
                              child: FormattedText(
                                  text: widget.message.text,
                                  formatStyle: BubbleStyles.getStyle(widget.message.own).textFormatStyle
                              )
                          ),
                        );
                      }
                  ),
                ),
              ),
            ),
          ),

          // Date text
          Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.message.state == MessageState.first ? BubbleStructure.compensatedPadding : BubbleStructure.horizontalPadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      DateFormat("HH:mm").format(widget.message.date),
                      style: BubbleStyles.getStyle(widget.message.own).dateTextStyle
                  ),
                  if (widget.message.own) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Icon(
                        Icons.circle,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 3,),
                    ),
                    if (widget.message.status == MessageStatus.sending) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: SizedBox(
                            width: 10.0,
                            height: 10.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                            )
                        ),
                      )
                    ] else if (widget.message.status == MessageStatus.error) ...[
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
              )
          )
        ],
      ),
    );
  }
}

