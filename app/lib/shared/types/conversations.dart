import 'package:flutter/material.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';

class ReceiverEntry extends Taggable {
  final String id;
  final String name;

  const ReceiverEntry(this.id, this.name);

  @override
  List<Object> get props => [name];
}

class ChatCreationData {
  final ChatType type;
  final String subject;
  final List<String> receivers;

  ChatCreationData({required this.type, required this.subject, required this.receivers});
}

class CreationResponse {
  final bool success;
  String? id;

  CreationResponse({required this.success, this.id});
}

enum ChatType {
  noAnswerAllowed("Keine Antwort auf diese Konversation wird möglich sein.", Icons.speaker_notes_off, "Hinweis"),
  privateAnswerOnly("Antworten können nur von dir gesehen werden.", Icons.mic, "Mitteilung"),
  groupOnly("Antworten können von jeden gesehen werden.", Icons.forum, "Gruppenchat"),
  openChat("Antworten können von jeden oder nur von bestimmten Personen gesehen werden, jedoch aktuell in der App kann man nur an jeden Nachrichten schreiben.", Icons.groups, "Offener Chat");

  final String description;
  final IconData icon;
  final String descriptiveName;

  const ChatType(this.description, this.icon, this.descriptiveName);
}

class Conversation {
  final bool groupChat;
  final bool onlyPrivateAnswers;

  final bool noReply;

  final UnparsedMessage parent;
  final List<UnparsedMessage> replies;

  const Conversation({required this.groupChat, required this.onlyPrivateAnswers, required this.noReply, required this.parent, this.replies = const []});
}

class UnparsedMessage {
  final String date;
  final String author;
  final bool own;
  final String content;

  const UnparsedMessage({required this.date, required this.author, required this.own, required this.content});
}