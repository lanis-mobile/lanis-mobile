import 'package:flutter/material.dart';

class LargeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final Text title;
  const LargeAppBar({super.key, required this.title, this.backgroundColor});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 88);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(88),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 28),
              child: title,
            ),
          ],
        ),
      ),
    );
  }
}

