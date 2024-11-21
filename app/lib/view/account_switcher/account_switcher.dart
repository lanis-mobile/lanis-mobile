import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sph_plan/core/database/account_database/account_db.dart';
import 'package:sph_plan/view/login/auth.dart';

import 'account_list_tile.dart';

class AccountSwitcher extends StatefulWidget {
  const AccountSwitcher({super.key});

  @override
  State<AccountSwitcher> createState() => _AccountSwitcherState();
}

class _AccountSwitcherState extends State<AccountSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Account'),
      ),
      body: StreamBuilder(
        stream: accountDatabase.select(accountDatabase.accountsTable).watch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Padding(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                body: LoginForm(),
                              ),
                            )
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add),
                            const SizedBox(width: 8),
                            const Text('Add Account'),
                          ],
                        ),
                      ),
                    )),
                    Divider(),
                  ],
                );
              }

              final account = snapshot.data![index - 1];
              return AccountListTile(
                schoolName: account.schoolName,
                userName: account.username,
                lastLogin: account.lastLogin ?? DateTime.now(),
                onTap: () {
                  accountDatabase.setNextLogin(account.id);
                  Phoenix.rebirth(context);
                }, dbID: account.id,
              );
            },
          );
        },
      ),
    );
  }
}
