import 'package:flutter/material.dart';

typedef ConversationsLayoutSideBuilder = Widget Function(
  BuildContext context,
  bool isTablet,
);

class ConversationsLayoutBuilder extends StatelessWidget {
  final ConversationsLayoutSideBuilder leftBuilder;
  final ConversationsLayoutSideBuilder? rightBuilder;
  final Widget rightPlaceholder;
  final Function onPopRight;

  const ConversationsLayoutBuilder(
      {super.key,
      required this.leftBuilder,
      this.rightBuilder,
      required this.rightPlaceholder,
      required this.onPopRight});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final int widthParts =
            constraints.maxWidth ~/ 350 == 0 ? 1 : constraints.maxWidth ~/ 350;

        if (isTablet) {
          return Row(
            children: [
              Expanded(
                flex: widthParts >= 3 ? 1 : 4,
                child: leftBuilder(context, isTablet),
              ),
              Container(
                width: 1,
                height: double.infinity,
                color: Theme.of(context).dividerColor,
              ),
              Expanded(
                flex: widthParts >= 3 ? 2 : 6,
                child: rightBuilder != null
                    ? rightBuilder!(context, isTablet)
                    : rightPlaceholder,
              ),
            ],
          );
        } else {
          return Stack(
            children: [
              leftBuilder(context, isTablet),
              if (rightBuilder != null) rightBuilder!(context, isTablet)
            ],
          );
        }
      },
    );
  }
}
