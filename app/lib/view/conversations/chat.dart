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
  final String uniqueID;
  final String? title;

  const ConversationsChat({super.key, required this.uniqueID, required this.title,});

  @override
  State<ConversationsChat> createState() => _ConversationsChatState();
}

class _ConversationsChatState extends State<ConversationsChat> {
  late final Future<dynamic> _conversationFuture = _initConversation();

  late final String groupOnly;
  late final String privateAnswerOnly;

  final List<types.Message> _messages = [];
  final Map<String, types.User> _users = {};
  final _me = const types.User(id: 'me');

  int parseDateString(String date) {
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

  Future<void> _sendMessage(types.PartialText message, String groupOnly, String privateAnswerOnly) async {


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

    bool result = await client.conversations.replyToConversation(
      widget.uniqueID,
      "all",
        groupOnly,
        privateAnswerOnly,
        message.text
    );

    setState(() {
      if (result) {
        _messages[_messages.indexOf(textMessage)] = _messages[_messages.indexOf(textMessage)].copyWith(status: types.Status.sent);
      } else {
        _messages[_messages.indexOf(textMessage)] = _messages[_messages.indexOf(textMessage)].copyWith(status: types.Status.error);
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
      createdAt: parseDateString(message["Datum"]),
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
    dynamic response = await client.conversations.getSingleConversation(widget.uniqueID);

    groupOnly = response["groupOnly"];
    privateAnswerOnly = response["privateAnswerOnly"];

    _initMessages(response);
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
              return Chat(
                messages: _messages,
                onSendPressed: (types.PartialText message) async {
                  await _sendMessage(
                    message,
                    groupOnly,
                    privateAnswerOnly
                  );
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
