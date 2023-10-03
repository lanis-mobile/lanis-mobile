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

  dynamic userData = client.userData;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }



  Future<void> loadUserData() async {
    setState(() {
      userDataListTiles.clear();
      userData.forEach((final String key, final value) {
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
            onPressed: loadUserData,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}