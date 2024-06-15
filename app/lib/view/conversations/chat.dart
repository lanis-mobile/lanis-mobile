import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/shared/widgets/dynamic_appbar.dart';

import '../../client/client.dart';
import '../../shared/exceptions/client_status_exceptions.dart';
import '../../shared/types/conversations.dart';
import '../../shared/widgets/error_view.dart';

enum MessageStatus {
  sending(Icons.pending),
  sent(Icons.check_circle),
  error(Icons.error);

  final IconData icon;

  const MessageStatus(this.icon);
}

enum MessageState {
  first,
  series;
}

class Message {
  final String text;
  final bool own;
  final String? author;
  final DateTime date;
  final MessageState state;
  MessageStatus status;

  Message({required this.text, required this.own, required this.date, required this.author, required this.state, required this.status});
}

class DateHeader {
  final DateTime date;
  const DateHeader({required this.date});
}

class AuthorHeader {
  final String author;
  const AuthorHeader({required this.author});
}

class ConversationSettings {
  final String id; // uniqueId
  final bool groupChat;
  final bool onlyPrivateAnswers;
  final bool noReply;
  final bool own;
  final String? author;

  const ConversationSettings({required this.id, required this.groupChat, required this.onlyPrivateAnswers, required this.noReply, required this.own, this.author});
}

class ConversationsChat extends StatefulWidget {
  final String? id; // uniqueId
  final String title;
  final PartialChat? creationData;

  const ConversationsChat({super.key, required this.title, this.id, this.creationData});

  @override
  State<ConversationsChat> createState() => _ConversationsChatState();
}

class _ConversationsChatState extends State<ConversationsChat> {
  late final Future<dynamic> _conversationFuture = initConversation();

  final TextEditingController _messageField = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ValueNotifier<bool> _deactivateSendButton = ValueNotifier<bool>(false);

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

  Future<void> newConversation(String text) async {
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

  Message parseMessage(dynamic message, MessageState position) {
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

  void initMessages(dynamic unparsedMessages) {
    DateTime date = parseDateString(unparsedMessages["Datum"]);
    String author = unparsedMessages["username"];
    MessageState position = MessageState.first;
    
    chat.addAll([
      DateHeader(date: date),
      AuthorHeader(author: author),
      parseMessage(unparsedMessages, position)
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
        chat.add(parseMessage(current, position));
      } else if (date.isSameDay(currentDate) && current["username"] != author) {
        author = current["username"];
        chat.addAll([
          AuthorHeader(author: author),
          parseMessage(current, position)
        ]);
      } else if (!date.isSameDay(currentDate) && current["username"] == author) {
        date = currentDate;
        chat.addAll([
          DateHeader(date: date),
          AuthorHeader(author: author),
          parseMessage(current, position)
        ]);
      } else {
        date = currentDate;
        author = current["username"];
        chat.addAll([
          DateHeader(date: date),
          AuthorHeader(author: author),
          parseMessage(current, position)
        ]);
      }
    }
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

    initMessages(response);
  }

  Widget AuthorHeaderBuilder(AuthorHeader header) {
    return Text(header.author);
    // TODO: STYLING
  }

  Widget DateHeaderBuilder(DateHeader header) {
    return Text(DateFormat("d. MMMM y").format(header.date));
    // TODO: STYLING
  }

  Widget BubbleBuilder(Message message) {
    // TODO: Restructure BubbleBuilder!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // TODO: IMPLEMENT LANIS-STYLE FORMATTING
    // TODO: DIFFERENT COLOURS ON MORE THAN 2 RECEIVERS
    // TODO: HOLD TO COPY
    const double nipWidth = 12.0;
    const double horizontalPadding = 8.0;
    const double horizontalMargin = 14.0;

    final double combinedMargin = message.state == MessageState.first ? horizontalMargin + nipWidth : horizontalMargin;

    late final Color color;
    late final CrossAxisAlignment crossAxisAlignment;
    late final TextStyle messageTextStyle;
    late final CustomClipper<Path> firstPositionStyle;
    final TextStyle dateTextStyle = Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurface);
    late final EdgeInsets margin;
    late final TextAlign textAlign;

    if (message.own) {
      color = Theme.of(context).colorScheme.primary;
      crossAxisAlignment = CrossAxisAlignment.end;
      messageTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary);
      firstPositionStyle = ChatBubbleClipper1(
        type: BubbleType.sendBubble,
        nipWidth: nipWidth,
        nipHeight: 14,
        radius: 20,
        nipRadius: 4
      );
      margin = EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: horizontalMargin,
          right: combinedMargin
      );
      textAlign = TextAlign.end;
    } else {
      color = Theme.of(context).colorScheme.secondary;
      crossAxisAlignment = CrossAxisAlignment.start;
      messageTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary);
      firstPositionStyle = ChatBubbleClipper1(
        nipWidth: nipWidth,
        nipHeight: 14,
        radius: 20,
        nipRadius: 4
      );
      margin = EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: combinedMargin,
          right: horizontalMargin
      );
      textAlign = TextAlign.start;
    }

    final EdgeInsets padding = EdgeInsets.only(
        left: message.state == MessageState.first ? horizontalPadding : horizontalPadding + nipWidth,
        right: message.state == MessageState.first ? horizontalPadding : horizontalPadding + nipWidth,
        bottom: 8.0
    );

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          ClipPath(
            clipper: message.state == MessageState.first ? firstPositionStyle : null,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 350, //TODO: MAKE IT DYNAMIC TO SCREEN
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: message.state != MessageState.first ? BorderRadius.circular(20.0) : null
                ),
                child: Padding(
                  padding: margin,
                  child: SelectableText(
                    message.text,
                    style: messageTextStyle,
                    textAlign: textAlign,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: message.state == MessageState.first ? combinedMargin : horizontalMargin),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat("HH:mm").format(message.date),
                  style: dateTextStyle,
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
                            return BubbleBuilder(chat[index]);
                          } else if (chat[index] is DateHeader) {
                            return DateHeaderBuilder(chat[index]);
                          } else {
                            return AuthorHeaderBuilder(chat[index]);
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
