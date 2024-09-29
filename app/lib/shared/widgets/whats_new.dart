import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../client/client.dart';
import '../../client/storage.dart';

void showUpdateInfoIfRequired(BuildContext context) async {
  final latestReleaseInfo = await getReleaseInfo(null);
  if (latestReleaseInfo == null) return;
  final String latestReleaseTag = latestReleaseInfo['tag_name'];
  final String deviceReleaseTag = await getDeviceReleaseTag();
  final String storageReleaseTag = await globalStorage.read(key: StorageKey.lastAppVersion);
  if (storageReleaseTag != deviceReleaseTag) {
    if (latestReleaseTag == deviceReleaseTag) {
      await globalStorage.write(key: StorageKey.lastAppVersion, value: deviceReleaseTag);
      await showDialog(
        context: context,
        builder: (context) => ReleaseNotesScreen(latestReleaseInfo),
      );
    } else {
      final deviceReleaseInfo = await getReleaseInfo(deviceReleaseTag);
      if (deviceReleaseInfo == null) return;
      await showDialog(
        context: context,
        builder: (context) => ReleaseNotesScreen(deviceReleaseInfo),
      );
    }
  }
  if (latestReleaseTag != deviceReleaseTag) {
    await showDialog(
      context: context,
      builder: (context) => NewUpdateAvailableDialog(
        deviceReleaseTag: deviceReleaseTag,
        latestReleaseTag: latestReleaseTag,
        releaseInfo: latestReleaseInfo,
      ),
    );
  }
}

Future<String> getDeviceReleaseTag() async {
  final packageInfo = await PackageInfo.fromPlatform();
  
  final String currentVersion = packageInfo.version;
  final String buildNumber = packageInfo.buildNumber;

  return ("v$currentVersion+$buildNumber");
}

Future<Map?> getReleaseInfo(String? releaseTag) async {
  String url = 'https://api.github.com/repos/lanis-mobile/lanis-mobile/releases/latest';
  if (releaseTag != null) {
    url = 'https://api.github.com/repos/octocat/Hello-World/releases/$releaseTag';
  }
  final response = await client.dio.get(url);
  return response.data;
}

class ReleaseNotesScreen extends StatelessWidget {
  final Map releaseInfo;
  const ReleaseNotesScreen(this.releaseInfo, {super.key});

  ///load contributors from markdown by searching for @username patterns
  List<String> getContributors(String markdownString) {
    final RegExp regExp = RegExp(r'@([a-zA-Z0-9_]+)');
    final Iterable<RegExpMatch> matches = regExp.allMatches(markdownString);
    final List<String> contributors = [];
    for (final match in matches) {
      final String contributor = match.group(1)!;
      if (!contributors.contains(contributor)) {
        contributors.add(contributor);
      }
    }
    return contributors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update ${releaseInfo['tag_name']}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              launchUrl(Uri.parse(releaseInfo['html_url']));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Markdown(
              data: releaseInfo['body'] ?? 'failed to load release data',
              padding: const EdgeInsets.all(16),
              onTapLink: (text, href, title) {
                launchUrl(Uri.parse(href!));
              },
            ),
          ),
          const Divider(),
          Wrap(
            children: getContributors(releaseInfo['body']??'').map((contributor) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse('https://github.com/$contributor'));
                  },
                  child: ClipOval(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      'https://github.com/$contributor.png?size=60',
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Text("Contributors", style: Theme.of(context).textTheme.labelLarge),
          const Divider(),
          Text("Become a contributor!", style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 32),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.done),
        label: const Text("Fertig"),
      ),
    );
  }
}

class NewUpdateAvailableDialog extends StatelessWidget {
  const NewUpdateAvailableDialog({super.key, required this.deviceReleaseTag, required this.latestReleaseTag, required this.releaseInfo});
  final String deviceReleaseTag;
  final String latestReleaseTag;
  final Map releaseInfo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.update, size: 56,),
      title: const Text("Neues Update verfügbar"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(deviceReleaseTag, style: Theme.of(context).textTheme.bodyLarge,),
          const Icon(Icons.arrow_forward),
          Text(latestReleaseTag, style: Theme.of(context).textTheme.bodyLarge,),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Release Notes"),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ReleaseNotesScreen(releaseInfo),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            launchStore();
          },
          child: const Text("Installieren"),
        ),]
    );
  }
}

void launchStore() {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=io.github.alessioc42.sph"
            : "https://apps.apple.com/app/id6511247743",
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  } on PlatformException {
    launchUrl(Uri.parse(
      Platform.isAndroid
          ? "https://play.google.com/store/apps/details?id=io.github.alessioc42.sph"
          : "https://apps.apple.com/app/id6511247743",
    ));
  }
}