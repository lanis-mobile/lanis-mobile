import 'package:flutter/material.dart';

import '../../core/sph/sph.dart';

class AccountListTile extends StatelessWidget {
  final int dbID;
  final String schoolName;
  final String userName;
  final DateTime lastLogin;
  final Function? onTap;

  const AccountListTile(
      {super.key,
      required this.schoolName,
      required this.userName,
      required this.lastLogin,
      required this.dbID,
      this.onTap});

  String get lastLoginInDays {
    final days = DateTime.now().difference(lastLogin).inDays;
    return days == 0 ? 'Today' : '$days days ago';
  }

  bool get isLoggedInAccount => sph?.account.localId == dbID;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: isLoggedInAccount ? Theme.of(context).primaryColor : null,
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
          trailing: IconButton(
            icon: Icon(Icons.logout),
            onPressed: (){},
          ),
          onTap: () => onTap?.call(),
        ),
        Divider(),
      ],
    );
  }
}
