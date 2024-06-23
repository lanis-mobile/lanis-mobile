import 'package:flutter/services.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/shared/widgets/dynamic_appbar.dart';

import '../../client/client.dart';
import '../../shared/exceptions/client_status_exceptions.dart';
import '../../shared/types/conversations.dart';
import '../../shared/widgets/error_view.dart';
import 'chat_classes.dart';

class ConversationsChat extends StatefulWidget {
  final String? id; // uniqueId
  final String title;
  final PartialChat? creationData;

  const ConversationsChat({super.key, required this.title, this.id, this.creationData});

  @override
  State<ConversationsChat> createState() => _ConversationsChatState();
}

class _ConversationsChatState extends State<ConversationsChat> with TickerProviderStateMixin {
  late final Future<dynamic> _conversationFuture = initConversation();

  final TextEditingController _messageField = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ValueNotifier<bool> _deactivateSendButton = ValueNotifier<bool>(false);

  final Map<String, TextStyle> textStyles = {};

  ConversationSettings? settings;

  final List<dynamic> chat = [];

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

  void addAuthorTextStyles(final List<String> authors) {
    for (final String author in authors) {
      textStyles[author] = BubbleStyle.getAuthorTextStyle(context, author);
    }
  }

  Future<void> newConversation(String text) async {
    addAuthorTextStyles(widget.creationData!.receivers);

    final textMessage = Message(
      text: text,
      own: true,
      date: DateTime.now(),
      author: null,
      state: MessageState.first,
      status: MessageStatus.sending,
    );

    setState(() {
      chat.addAll([
        DateHeader(date: DateTime.now()),
        textMessage
      ]);
    });

    final dynamic newConversation = await client.conversations.createConversation(widget.creationData!.receivers, widget.creationData!.type.name, widget.creationData!.subject, text);

    final bool result = newConversation["back"];
    if (result) {
      chat.last.status = MessageStatus.sent;
      settings = ConversationSettings(
        id: newConversation["id"],
        groupChat: widget.creationData!.type == ChatType.groupOnly,
        onlyPrivateAnswers: widget.creationData!.type == ChatType.privateAnswerOnly,
        noReply: false,
        own: true
      );
    } else {
      chat.last.status = MessageStatus.error;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.error),
              title: const Text("Es konnte keine neue Konversation erstellt werden!"),
              actions: [
                FilledButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok")
                ),
              ],
            );
          }
      );
    }
  }

  Future<void> sendMessage(String text) async {
    final textMessage = Message(
        text: text,
        own: true,
        date: DateTime.now(),
        author: null,
        state: MessageState.first,
        status: MessageStatus.sending,
    ); // TODO: position

    setState(() {
      if (chat.last.date.isToday()) {
        chat.add(textMessage);
      } else {
        chat.addAll([
          DateHeader(date: DateTime.now()),
          textMessage
        ]);
      }
    });

    final bool result = await client.conversations.replyToConversation(
        settings!.id,
        "all",
        settings!.groupChat ? "ja" : "nein",
        settings!.onlyPrivateAnswers ? "ja" : "nein",
        text
    );

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
    if (widget.id == null) {
      return;
    }

    dynamic response = await client.conversations.getSingleConversation(widget.id!);

    /*if (privateAnswerOnly == "ja" && response["own"] == false) {
      replyReceiver = response["username"];
    } else {
      replyReceiver = null;
    }*/

    settings = ConversationSettings(
      id: widget.id!,
      groupChat: response["groupOnly"] == "ja",
      onlyPrivateAnswers: response["privateAnswerOnly"] == "ja",
      noReply: response["noAnswerAllowed"] == "ja" ? true : false,
      author: response["username"],
      own: response["own"]
    );

    parseMessages(response);
  }

  Widget DateHeaderBuilder(DateHeader header) {
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

  Widget MessageBuilder(Message message) {
    // TODO: IMPLEMENT LANIS-STYLE FORMATTING
    ValueNotifier<bool> tapped = ValueNotifier(false);
    final AnimationController controller = AnimationController(vsync: this);

    return Padding(
      padding: BubbleStructure.getMargin(message.state),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: BubbleStructure.getAlignment(message.own),
        children: [
          // Author name
          if (message.state == MessageState.first && !message.own) ...[
            Text(
                message.author!,
              style: textStyles[message.author],
            )
          ],
          // Message bubble
          ClipPath(
            clipper: message.state == MessageState.first ? BubbleStructure.getFirstStateClipper(message.own) : null,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 350, //TODO: MAKE IT DYNAMIC TO SCREEN
              ),
              child: GestureDetector(
                onLongPress: () async {
                  tapped.value = false;
                  HapticFeedback.vibrate();
                  await Clipboard.setData(ClipboardData(text: message.text));
                  showSnackbar("Nachricht wurde kopiert!");
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
                  tapped.value = false;
                },
                child: Animate(
                  autoPlay: false,
                  effects: const [ShimmerEffect(
                    duration: Duration(milliseconds: 600)
                  )],
                  controller: controller,
                  child: ValueListenableBuilder(
                    valueListenable: tapped,
                    builder: (context, value, _) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: value ? BubbleStyle.getPressedColor(context, message.own) : BubbleStyle.getColor(context, message.own),
                          borderRadius: message.state != MessageState.first ? BubbleStructure.radius : null
                        ),
                        child: Padding(
                          padding: BubbleStructure.getPadding(message.state == MessageState.first, message.own),
                          child: Text(
                            message.text,
                            style: BubbleStyle.getTextStyle(context, message.own),
                            textAlign: TextAlign.start,
                          ),
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
            padding: EdgeInsets.symmetric(horizontal: message.state == MessageState.first ? BubbleStructure.compensatedPadding : BubbleStructure.horizontalPadding),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat("HH:mm").format(message.date),
                  style: BubbleStyle.getDateTextStyle(context)
                ),
                if (message.own) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(
                      Icons.circle,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 3,),
                  ),
                  Icon(
                    message.status.icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 12,
                  )
                ]
              ],
            )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: See Receivers
    return Scaffold(
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

              return Stack(
                alignment: Alignment.bottomLeft,
                fit: StackFit.loose,
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      DynamicAppBar(
                        scrollController: _scrollController,
                        title: Text(widget.title),
                        expanded: [
                          Text(widget.title),
                          if (settings != null && settings!.onlyPrivateAnswers && !settings!.own) ...[
                            Text("${settings!.author} kann nur deine Nachrichten sehen!")
                          ]
                        ],
                      ), // TODO: Correctly style App Bar
                      SliverList.builder(
                        itemCount: chat.length,
                        itemBuilder: (context, index) {
                          if (chat[index] is Message) {
                            return MessageBuilder(chat[index]);
                          } else {
                            return DateHeaderBuilder(chat[index]);
                          }
                        },
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 60,
                        ),
                      )
                    ],
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageField,
                          ), // TODO: RichTextField as separate Dialog or so, bc Nachrichten is more used like handicapped E-Mails
                        ),
                        ValueListenableBuilder(
                            valueListenable: _deactivateSendButton,
                            builder: (context, deactivated, _) {
                              return IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: deactivated ? null : () async {
                                  _deactivateSendButton.value = true;
                                  if (settings == null) {
                                    await newConversation(_messageField.text);
                                  } else {
                                    await sendMessage(_messageField.text);
                                  }
                                  _deactivateSendButton.value = false;
                                },
                              );
                            }
                        )
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
          }
      )
    );
  }
}
