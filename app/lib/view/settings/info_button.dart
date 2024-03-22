import 'package:flutter/material.dart';

class InfoButton extends IconButton {
  final String infoText;
  late final BuildContext context;

  InfoButton({super.key, required this.infoText, required this.context})
      : super(
          icon: const Icon(Icons.info),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Information",
                          style: Theme.of(context).textTheme.headlineSmall),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(infoText),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
}
