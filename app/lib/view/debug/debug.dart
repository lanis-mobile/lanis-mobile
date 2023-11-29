// maybe change this later to an list, or just delete it.

import '../../client/client.dart';

import 'package:flutter/material.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  bool status = client.getEncryptionAuthStatus();
  String key = client.getEncryptionKey();
  bool failure = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Debug - Verschlüsselung"),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: const Text("Verschlüsselung"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Authentifiziert: $status"),
                  if (status) ...[
                    Text("Key: $key"),
                  ],
                  ElevatedButton(
                    child: const Text("Authentifizieren."),
                    onPressed: () async {
                      bool success = await client.authenticateWithLanisEncryption();
                      if (success) {
                        setState(() {
                          status = true;
                          key = client.getEncryptionKey();
                        });
                      }
                      else {
                        failure = true;
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          if (failure) ...[
            const Card(
              child: ListTile(
                title: Text("Fehler"),
                textColor: Colors.redAccent,
              ),
            )
          ]
        ],
      ),
    );
  }
}
