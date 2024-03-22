import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../client/client.dart';

void launchFile(BuildContext context, String url, String filename, String? filesize, Function callback) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Download... ${filesize ?? ""}"),
          content: const Center(
            heightFactor: 1.1,
            child: CircularProgressIndicator(),
          ),
        );
      });
  client
      .downloadFile(url, filename)
      .then((filepath) {
    Navigator.of(context).pop();

    if (filepath == "") {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Fehler!"),
            content: Text(
                "Beim Download der Datei $filename ist ein unerwarteter Fehler aufgetreten. Wenn dieses Problem besteht, senden Sie uns bitte einen Fehlerbericht."),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    } else {
      OpenFile.open(filepath);
      callback(); // Call the callback function after the file is opened
    }
  });
}