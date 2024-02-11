import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ClearCacheScreen extends StatelessWidget {
  const ClearCacheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cache leeren"),
        ),
        body: const Body()
    );
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
      dir.listSync(recursive: true, followLinks: false)
          .forEach((FileSystemEntity entity) {
        if (entity is File) {
          fileNum++;
          totalSize += entity.lengthSync();
        }
      });
    }
    debugPrint(fileNum.toString());
    return {'fileNum': fileNum, 'size': totalSize};
  }

  void clearCache() async {
    final dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
    setState(() {
      cacheStats = dirStatSync(dir.path);
    });
  }

  @override
  void initState() {
    super.initState();
     getTemporaryDirectory().then((dir) {
      setState(() {
        cacheStats = dirStatSync(dir.path);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          leading: Icon(Icons.cached),
          title: Text('Cache'),
          subtitle: Text('Alle Dateien, die du jemals heruntergeladen hast bilden den Cache. Hier kannst du ihn leeren um Speicherplatz freizugeben.'),
        ),
        ListTile(
          leading: const Icon(Icons.file_download_sharp),
          title: const Text('Dateien'),
          trailing: Text(cacheStats['fileNum'].toString(), style: const TextStyle(fontSize: 28)),
          subtitle: Text('Größe: ${cacheStats['size']! ~/ 1024} KB'),
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever),
          title: const Text('Cache leeren'),
          onTap: (){
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
        )
      ],
    );
  }
}

