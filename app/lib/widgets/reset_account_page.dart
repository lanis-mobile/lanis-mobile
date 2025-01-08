import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/utils/large_appbar.dart';

import '../core/sph/sph.dart';

class ResetAccountPage extends StatefulWidget {
  const ResetAccountPage({super.key});

  @override
  State<ResetAccountPage> createState() => _ResetAccountPageState();
}

class _ResetAccountPageState extends State<ResetAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LargeAppBar(
        title: Text(AppLocalizations.of(context)!.resetAccount),
      ),
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Theme.of(context).colorScheme.tertiaryContainer),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.login, color: Theme.of(context).colorScheme.onSecondary,),
                      Text(sph!.account.username, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.account_balance, color: Theme.of(context).colorScheme.onSecondary,),
                      Text(sph!.account.schoolName, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.password, color: Theme.of(context).colorScheme.onSecondary.withRed(255),),
                      Text('••••••••••••••••••••', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary.withRed(255)),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("Wrong password!"),
            subtitle: Text("Your password seems to be wrong! This can happen, when you change your password or your account gets deleted. Either change your password or remove your account entirely to resolve the issue."),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              spacing: 4.0,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                  },
                  icon: Icon(Icons.password),
                  label: Text("Change password"),
                ),
                ElevatedButton.icon(
                  onPressed: (){

                  },
                  icon: Icon(Icons.no_accounts),
                  label: Text("Remove account"),
                ),
                ElevatedButton.icon(
                  onPressed: (){

                  },
                  icon: Icon(Icons.no_accounts),
                  label: Text("Remove all Accounts"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
