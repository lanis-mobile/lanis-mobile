import 'package:flutter/material.dart';

import '../../client/client.dart';

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

  Future<void> refreshUserData() async {
    var userData = await client.fetchUserData();
    client.userData = userData;
    await client.saveUserData(userData);
    loadUserData();
  }

  void loadUserData() {
    setState(() {
      userDataListTiles.clear();
      (client.userData ?? []).forEach((key, value) {
        userDataListTiles.add(ListTile(
          title: Text(value),
          subtitle: Text(key),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: userDataListTiles,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: refreshUserData,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}