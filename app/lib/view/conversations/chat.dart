import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../client/client.dart';
import '../../shared/exceptions/client_status_exceptions.dart';
import '../../shared/types/conversations.dart';
import '../../shared/widgets/error_view.dart';

class ConversationsChat extends StatefulWidget {
  final String? uniqueID;
  final String title;
  final PartialChat? creationData;

  const ConversationsChat({super.key, required this.title, this.uniqueID, this.creationData});

  @override
  State<ConversationsChat> createState() => _ConversationsChatState();
}

class _ConversationsChatState extends State<ConversationsChat> {
  late final Future<dynamic> _conversationFuture = _initConversation();

  String? uniqueId;

  late final String groupOnly;
  late final String privateAnswerOnly;
  bool? noReply;

  late final String? replyReceiver;

  final List<types.Message> _messages = [];
  final Map<String, types.User> _users = {};
  final _me = const types.User(id: 'me');

  int _parseDateString(String date) {
    if (date.contains("heute")) {
      DateTime now = DateTime.now();
      DateTime conversation = DateFormat("H:m").parse(date.substring(6));

      return now.copyWith(hour: conversation.hour, minute: conversation.minute, second: 0).millisecondsSinceEpoch;
    } else if (date.contains("gestern")) {
      DateTime yesterday = DateTime.now().subtract(const Duration(days:1));
      DateTime conversation = DateFormat("H:m").parse(date.substring(8));

      return yesterday.copyWith(hour: conversation.hour, minute: conversation.minute, second: 0).millisecondsSinceEpoch;
    } else {
      return DateFormat("d.M.y H:m").parse(date).millisecondsSinceEpoch;
    }
  }

  Future<bool> _pushMessage(String message) async {
    late final bool result;
    if (uniqueId != null) {
      result = await client.conversations.replyToConversation(
          uniqueId!,
          "all",
          groupOnly,
          privateAnswerOnly,
          message
      );
    } else {
      final dynamic newConversation = await client.conversations.createConversation(widget.creationData!.receivers, widget.creationData!.type.name, widget.creationData!.subject, message);
      result = newConversation["back"];
      if (result) uniqueId = newConversation["id"];
    }
    return result;
  }

  Future<void> _sendMessage(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _me,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
      status: types.Status.sending
    );
    setState(() {
      _messages.insert(0, textMessage);
    });

    final bool result = await _pushMessage(message.text);

    setState(() {
      if (result) {
        _messages[_messages.indexOf(textMessage)] = _messages[_messages.indexOf(textMessage)].copyWith(status: types.Status.sent);
      } else {
        _messages[_messages.indexOf(textMessage)] = _messages[_messages.indexOf(textMessage)].copyWith(status: types.Status.error);
        if (uniqueId == null) {
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
    });
  }

  types.TextMessage _parseMessage(dynamic message) {
    final contentParsed = parse(message["Inhalt"]);
    final content = contentParsed.body!.text;

    if (!(_users.containsKey(message["Sender"]))) {
      _users[message["Sender"]] = types.User(
          id: message["Sender"],
          firstName: message["username"]);
    }

    late final types.User user;
    if (message["own"]) {
      user = _me;
    } else {
      user = _users[message["Sender"]]!;
    }

    return types.TextMessage(
      text: content,
      author: user,
      id: message["Uniquid"],
      createdAt: _parseDateString(message["Datum"]),
      status: types.Status.sent
    );
  }

  void _initMessages(dynamic messages) {
    _messages.insert(0, _parseMessage(messages));

    for (dynamic message in messages["reply"]) {
      _messages.insert(0, _parseMessage(message));
    }
  }

  Future<void> _initConversation() async {
    if (widget.uniqueID == null) {
      return;
    }

    uniqueId = widget.uniqueID!;

    dynamic response = await client.conversations.getSingleConversation(uniqueId!);

    groupOnly = response["groupOnly"];
    privateAnswerOnly = response["privateAnswerOnly"];

    noReply = response["noAnswerAllowed"] == "ja" ? true : false;

    if (privateAnswerOnly == "ja" && response["own"] == false) {
      replyReceiver = response["username"];
    } else {
      replyReceiver = null;
    }

    _initMessages(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              return Chat(
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
