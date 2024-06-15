import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

class ConversationSettings {
  final String id; // uniqueId
  final bool groupChat;
  final bool onlyPrivateAnswers;
  final bool noReply;
  final bool own;
  final String? author;

  const ConversationSettings({required this.id, required this.groupChat, required this.onlyPrivateAnswers, required this.noReply, required this.own, this.author});
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

class DateHeader {
  final DateTime date;
  const DateHeader({required this.date});
}

class AuthorHeader {
  final String author;
  const AuthorHeader({required this.author});
}

class BubbleStructure {
  static const double nipWidth = 12.0;
  static const double horizontalMargin = 14.0;
  static const double compensatedMargin = horizontalMargin + nipWidth;
  static const double horizontalPadding = 8.0;
  static BorderRadius radius = BorderRadius.circular(20.0);

  static CrossAxisAlignment getAlignment(final bool own) {
    return own ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }

  static CustomClipper<Path> getFirstStateClipper(final bool own) {
    return ChatBubbleClipper1(
        type: own ? BubbleType.sendBubble : BubbleType.receiverBubble,
        nipWidth: nipWidth,
        nipHeight: 14,
        radius: 20,
        nipRadius: 4
    );
  }

  static EdgeInsets getMargin(final bool nipCompensation, final bool own) {
    final double margin = nipCompensation ? compensatedMargin : horizontalMargin;

    return EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: own ? horizontalMargin : margin,
        right: own ? margin : horizontalMargin
    );
  }

  static EdgeInsets getPadding(final bool nipCompensation) {
    final double combinedPadding = nipCompensation ? horizontalPadding : horizontalPadding + nipWidth;

    return EdgeInsets.only(
        left: combinedPadding,
        right: combinedPadding,
        bottom: 8.0
    );
  }
}

class BubbleStyle {
  static Color getColor(final BuildContext context, final bool own) => own ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary;

  static TextStyle getTextStyle(final BuildContext context, final bool own) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyMedium!;
    return own ? textStyle.copyWith(color: Theme.of(context).colorScheme.onPrimary) : textStyle.copyWith(color: Theme.of(context).colorScheme.onSecondary);
  }

  static TextStyle getDateTextStyle (final BuildContext context) => Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurface);
}