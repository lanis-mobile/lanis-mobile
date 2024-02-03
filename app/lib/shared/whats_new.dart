import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';


import '../client/client.dart';
import '../client/storage.dart';

Future<String?> whatsNew() async {
  final String currentVersion = await PackageInfo.fromPlatform().then((PackageInfo packageInfo) => packageInfo.version);
  final String storedVersion = await globalStorage.read(key: StorageKey.lastAppVersion);
  if (currentVersion != storedVersion) {
    debugPrint("New Version detected: $currentVersion");
    await globalStorage.write(key: StorageKey.lastAppVersion, value: currentVersion);

    String releaseNotes = await getReleaseMarkDown();
    return releaseNotes;
  } else {
    return null;
  }
}

Future<String> getReleaseMarkDown() async {
  try {
    final response = await client.dio.get('https://api.github.com/repos/alessioc42/lanis-mobile/releases/latest');
    return (response.data['body']);
  } catch (e) {
    debugPrint(e.toString());
    return "Fehler, beim Laden der Update Details.";
  }
}


void openReleaseNotesModal(BuildContext context, String releaseNotes) {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) => packageInfo.version).then((version) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Lanis Mobile v$version'),
          content: SizedBox( // AlertDialog doesn't support ListView, .... (viewport) widgets, so we need to constrain it.
            width: double.maxFinite,
            height: 300, // don't make it too big, don't make it too small
            child: Markdown( // Markdown is always a Listable? (viewport) widget, even MarkdownBody which isn't scrollable.
                data: releaseNotes,
                padding: const EdgeInsets.all(0),
                onTapLink: (text, href, title) {
                  launchUrl(Uri.parse(href!));
                }
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Schließen'),
            ),
          ],
        );
      },
    );
  });

}