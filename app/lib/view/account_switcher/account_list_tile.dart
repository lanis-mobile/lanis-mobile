import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  final String schoolName;
  final String userName;
  final DateTime lastLogin;
  final Function? onTap;

  const AccountListTile(
      {super.key,
      required this.schoolName,
      required this.userName,
      required this.lastLogin,
      this.onTap});

  String get lastLoginInDays {
    final days = DateTime.now().difference(lastLogin).inDays;
    return days == 0 ? 'Today' : '$days days ago';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: CircleAvatar(
            child: Text(userName[0]),
          ),
          title: Text(userName),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(schoolName),
              Text(lastLoginInDays),
            ],
          ),
          onTap: () => onTap?.call(),
        ),
        Divider(),
      ],
    );
  }
}
