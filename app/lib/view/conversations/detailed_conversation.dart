import 'package:flutter/material.dart';

import '../../client/client.dart';

class DetailedConversationAnsicht extends StatefulWidget {
  final String uniqueID;
  final String? title;
  const DetailedConversationAnsicht({super.key, required this.uniqueID, required this.title});

  @override
  State<DetailedConversationAnsicht> createState() => _DetailedConversationAnsichtState();
}

class _DetailedConversationAnsichtState extends State<DetailedConversationAnsicht> {
  late final Future<dynamic> _getSingleConversation;

  @override
  void initState() {
    super.initState();
    _getSingleConversation = client.getSingleConversation(widget.uniqueID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? "Nachricht"
        ),
      ),
      body: FutureBuilder(
          future: _getSingleConversation,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              print(snapshot.data);
              return Placeholder();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
    );
  }
}
