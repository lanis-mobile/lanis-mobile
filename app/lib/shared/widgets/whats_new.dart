import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../client/client.dart';
import '../../client/storage.dart';

Future<String?> whatsNew() async {
  final packageInfo = await PackageInfo.fromPlatform();
  
  final String currentVersion = packageInfo.version;
  final String buildNumber = packageInfo.buildNumber;

  final String storedVersion =
      await globalStorage.read(key: StorageKey.lastAppVersion);
  if (currentVersion != storedVersion) {
    await globalStorage.write(
        key: StorageKey.lastAppVersion, value: currentVersion);

    String releaseNotes = await getReleaseMarkDown("v$currentVersion+$buildNumber");
    return releaseNotes;
  } else {
    return null;
  }
}

Future<String> getReleaseMarkDown(String gitHubReleaseTag) async {
  try {
    final response = await client.dio.get(
        'https://api.github.com/repos/alessioc42/lanis-mobile/releases/tags/$gitHubReleaseTag');
    return (response.data['body']);
  } catch (e) {
    return "Fehler, beim Laden der Update Details.";
  }
}

class ReleaseNotesScreen extends StatelessWidget {
  final String releaseNotes;
  const ReleaseNotesScreen(this.releaseNotes, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Update ${snapshot.data?.version}"),
            ),
            body: Markdown(
                data: releaseNotes,
                padding: const EdgeInsets.all(16),
                onTapLink: (text, href, title) {
                  launchUrl(Uri.parse(href!));
                }),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.done),
              label: const Text("Fertig"),
            ),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Lade Update..."),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ));
        }
      },
    );
  }
}
