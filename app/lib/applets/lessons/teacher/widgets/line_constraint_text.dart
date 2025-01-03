import 'package:flutter/material.dart';

import '../../../../utils/logger.dart';

class LineConstraintText extends StatefulWidget {
  final String data;
  final int maxLines;
  final TextStyle? style;
  const LineConstraintText(
      {super.key, required this.data, this.maxLines = 1, this.style});

  @override
  State<LineConstraintText> createState() => _LineConstraintTextState();
}

class _LineConstraintTextState extends State<LineConstraintText> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logger.i('LineConstraintText onTap');
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Text(
        widget.data,
        maxLines: _expanded ? null : widget.maxLines,
        overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        style: widget.style,
      ),
    );
  }
}
