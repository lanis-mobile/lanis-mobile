import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../client/client.dart';


void shareFile(BuildContext context, String url, String filename, String? filesize, Function callback) {
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

  client.downloadFile(url, filename).then((filepath) async {
    Navigator.of(context).pop();

    if (filepath == "") {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("${AppLocalizations.of(context)!.error}!"),
            icon: const Icon(Icons.error),
            content: Text(
                AppLocalizations.of(context)!.reportError),
            actions: [
              TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse("https://github.com/alessioC42/lanis-mobile/issues"));
                  },
                  child: const Text("GitHub")
              ),
              OutlinedButton(
                  onPressed: () {
                    launchUrl(Uri.parse("mailto:alessioc42.dev@gmail.com"));
                  },
                  child: Text(AppLocalizations.of(context)!.startupReportButton)
              ),
              FilledButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    } else {
      await Share.shareXFiles([XFile(filepath)]);
      callback(); // Call the callback function after the file is opened
    }
  });
}
