import 'package:flutter/material.dart';

class MinimalSwitchTile extends StatelessWidget {
  final Text title;
  final Text? subtitle;
  final Widget? leading;
  final bool value;
  final EdgeInsets? contentPadding;
  final Function(bool)? onChanged;
  final bool useInkWell;

  const MinimalSwitchTile(
      {super.key,
      required this.title,
      this.subtitle,
      this.leading,
      required this.value,
      this.contentPadding,
      this.onChanged,
      this.useInkWell = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged != null && useInkWell
          ? () {
              onChanged!(!value);
            }
          : null,
      child: Padding(
        padding: contentPadding ?? EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: 16.0),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    if (subtitle != null) subtitle!,
                  ],
                ),
              ],
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
