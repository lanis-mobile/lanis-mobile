import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sph_plan/client/client.dart';

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
      userDataListTiles.add(const ListTile(
        leading: Icon(Icons.info),
        title: Text("Information"),
        subtitle: Text("Alle Benutzerdaten sind auf den Lanis-Servern gespeichert."),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Benutzerdaten"),
      ),
      body: ListView(
        children: userDataListTiles,
      ),
    );
  }
}