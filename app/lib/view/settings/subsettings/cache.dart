import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../client/client.dart';

class CacheScreen extends StatelessWidget {
  const CacheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.clearCache),
        ),
        body: const Body());
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Map<String, int> cacheStats = {'fileNum': 0, 'size': 0};

  Map<String, int> dirStatSync(String dirPath) {
    int fileNum = 0;
    int totalSize = 0;
    var dir = Directory(dirPath);

    if (dir.existsSync()) {
      dir
          .listSync(recursive: true, followLinks: false)
          .forEach((FileSystemEntity entity) {
        if (entity is File) {
          fileNum++;
          totalSize += entity.lengthSync();
        }
      });
    }
    return {'fileNum': fileNum, 'size': totalSize};
  }

  void clearCache() async {
    final dir = await client.getFileCacheDirectory();
    dir.deleteSync(recursive: true);
    setState(() {
      cacheStats = dirStatSync(dir.path);
    });
  }

  @override
  void initState() {
    super.initState();
    client.getFileCacheDirectory().then((dir) {
      setState(() {
        cacheStats = dirStatSync(dir.path);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.cached),
          title: Text(AppLocalizations.of(context)!.cache),
          subtitle: Text(AppLocalizations.of(context)!.settingsInfoClearCache),
        ),
        ListTile(
          leading: const Icon(Icons.file_download_sharp),
          title: Text(AppLocalizations.of(context)!.files),
          trailing: Text(cacheStats['fileNum'].toString(),
              style: const TextStyle(fontSize: 28)),
          subtitle: Text(
              '${AppLocalizations.of(context)!.size}: ${cacheStats['size']! ~/ 1024} KB'),
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever),
          title: Text(AppLocalizations.of(context)!.clearCache),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Cache leeren'),
                  content: const Text('Möchtest du wirklich den Cache leeren?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Abbrechen'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Leeren'),
                      onPressed: () {
                        clearCache();
                        Navigator.of(context).pop(); //pop the dialog
                        Navigator.of(context).pop(); //go to settings overview
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
