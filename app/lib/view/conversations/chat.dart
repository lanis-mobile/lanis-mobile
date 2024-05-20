import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/shared/widgets/dynamic_appbar.dart';

import '../../client/client.dart';
import '../../shared/exceptions/client_status_exceptions.dart';
import '../../shared/types/conversations.dart';
import '../../shared/widgets/error_view.dart';

enum MessageStatus {
  sending,
  sent,
  error
}

class Message {
  final String text;
  final bool own;
  final DateTime date;
  MessageStatus status;

  Message({required this.text, required this.own, required this.date, required this.status});
}

class ConversationSettings {
  final String id; // uniqueId
  final String groupChat;
  final String onlyPrivateAnswers;
  final bool noReply;

  const ConversationSettings({required this.id, required this.groupChat, required this.onlyPrivateAnswers, required this.noReply});
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

  late final String? replyReceiver;

  final List<Message> messages = [];

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
        status: MessageStatus.sending
    );
    setState(() {
      messages.add(textMessage);
    });

    print(widget.creationData!.receivers);
    final dynamic newConversation = await client.conversations.createConversation(widget.creationData!.receivers, widget.creationData!.type.name, widget.creationData!.subject, text);

    final bool result = newConversation["back"];
    if (result) {
      messages.last.status = MessageStatus.sent;
      settings = ConversationSettings(
          id: newConversation["id"],
          groupChat: widget.creationData!.type == ChatType.groupOnly ? "ja" : "nein",
          onlyPrivateAnswers: widget.creationData!.type == ChatType.privateAnswerOnly ? "ja" : "nein",
          noReply: false
      );
    } else {
      messages.last.status = MessageStatus.error;
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
      status: MessageStatus.sending
    );
    setState(() {
      messages.add(textMessage);
    });

    final bool result = await client.conversations.replyToConversation(
        settings!.id,
        "all",
        settings!.groupChat,
        settings!.onlyPrivateAnswers,
        text
    );

    setState(() {
      if (result) {
        messages.last.status = MessageStatus.sent;
        print(result);
      } else {
        messages.last.status = MessageStatus.error;
      }
    });
  }

  Message parseMessage(dynamic message) {
    final contentParsed = parse(message["Inhalt"]);
    final content = contentParsed.body!.text;

    /*if (!(_users.containsKey(message["Sender"]))) {
      _users[message["Sender"]] = types.User(
          id: message["Sender"],
          firstName: message["username"]);
    }*/

    /*late final types.User user;
    if () {
      user = _me;
    } else {
      user = _users[message["Sender"]]!;
    }*/

    return Message(
      text: content,
      own: message["own"],
      date: parseDateString(message["Datum"]),
      status: MessageStatus.sent
    );
    /*return types.TextMessage(
      text: content,
      author: user,
      id: message["Uniquid"],
      createdAt: _parseDateString(message["Datum"]),
      status: types.Status.sent
    );*/
  }

  void initMessages(dynamic unparsedMessages) {
    messages.add(parseMessage(unparsedMessages));

    for (dynamic unparsed in unparsedMessages["reply"]) {
      messages.add(parseMessage(unparsed));
    }
  }

  Future<void> initConversation() async {
    if (widget.id == null) {
      print(widget.creationData!.subject);
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
        groupChat: response["groupOnly"],
        onlyPrivateAnswers: response["privateAnswerOnly"],
        noReply: response["noAnswerAllowed"] == "ja" ? true : false
    );

    initMessages(response);
  }

  Widget bubble(Message message) {
    return Row(
      mainAxisAlignment: message.own ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        SelectableText(
          message.text,
        ),
        Text("${message.date.hour}:${message.date.minute}")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          Text(widget.title)
                        ],
                      ),
                      SliverList.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return bubble(messages[index]);
                        },
                      ),
                    ],
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageField,
                          ),
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
              /*
              * return Chat(
                messages: _messages,
                customBottomWidget: noReply == true || noReply == null ? const SizedBox.shrink() : null,
                /*listBottomWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    "Deine Nachricht kommt nur an $replyReceiver an",
                    textAlign: TextAlign.center,
                  ),
                ),*/ // --> TODO: Move it under the BottomWidget, when I make a custom one.
                onSendPressed: (types.PartialText message) async {
                  if (uniqueId == null) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            icon: const Icon(Icons.question_mark),
                            title: const Text("Bist du dir sicher?"),
                            content: const Text("Mit dieser Nachricht erstellst du eine neue Konversation!"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Zurück")
                              ),
                              FilledButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await _sendMessage(
                                        message
                                    );
                                  },
                                  child: const Text("Erstellen")
                              ),
                            ],
                          );
                        }
                    );
                  } else {
                    await _sendMessage(
                        message
                    );
                  }
                },
                user: _me,
                showUserNames: true,
              );*/
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
