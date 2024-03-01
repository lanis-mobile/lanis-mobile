import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/view/settings/info_button.dart';

class UserdataAnsicht extends StatefulWidget {
  const UserdataAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _UserdataAnsichtState();
}

class _UserdataAnsichtState extends State<UserdataAnsicht> {
  double padding = 10.0;

  List<ListTile> userDataListTiles = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() {
    setState(() {
      userDataListTiles.clear();
      (client.userData ?? []).forEach((key, value) {
        userDataListTiles.add(ListTile(
          title: Text(value),
          subtitle: Text(toBeginningOfSentenceCase(key)!),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Benutzerdaten"),
        actions: [
          InfoButton(infoText: "Alle Benutzerdaten sind auf den Lanis-Servern gespeichert.", context: context)
        ],
      ),
      body: ListView(
        children: userDataListTiles,
      ),
    );
  }
}