import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/utils/large_appbar.dart';

import '../../../core/sph/sph.dart';
import '../../../utils/callout.dart';

class CacheSettings extends StatefulWidget {
  const CacheSettings({super.key});

  static Map<String, int> dirStatSync(String dirPath) {
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

  @override
  State<CacheSettings> createState() => _CacheSettingsState();
}

class _CacheSettingsState extends State<CacheSettings> {
  Map<String, int> cacheStats = {'fileNum': 0, 'size': 0};

  Future<void> clearCache() async {
    final dir = await sph!.storage.getDocumentCacheDirectory();
    dir.deleteSync(recursive: true);

    setState(() {
      cacheStats = CacheSettings.dirStatSync(dir.path);
    });
  }

  @override
  void initState() {
    super.initState();

    sph!.storage.getDocumentCacheDirectory().then((dir) {
      setState(() {
        cacheStats = CacheSettings.dirStatSync(dir.path);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      appBar: LargeAppBar(
          title: Text(
            "Clear cache"
          )
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            Text(
              "All files that you have ever downloaded form the cache. You can empty it here to free up storage space. Documents older than 7 days are automatically deleted. ",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
            ),
            SizedBox(height: 24.0,),
            Callout(
              leading: Icon(Icons.delete_forever_rounded),
              title: Text("Do you want to permanently empty your cache?"),
              buttonText: Text(
                  cacheStats['fileNum'] != 0 ? "Clear cache" : "Cache is empty!",
              ),
              onPressed: cacheStats['fileNum'] != 0 ? () {
                clearCache();
              } : null,
            ),
            SizedBox(height: 24.0,),
            Text(
              "Space used",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(height: 16.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${cacheStats['fileNum'].toString()} ${cacheStats['fileNum'] == 1 ? "file" : "files"}",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                Text(
                  "${cacheStats['size']! ~/ 1024} KB",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            SizedBox(
              height: 28.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20.0,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Other storage settings, like resetting the whole app storage, can be found in the ",
                    style:
                    Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                  TextSpan(
                    text: "system settings",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        AppSettings.openAppSettings();
                      },
                  ),
                  TextSpan(
                    text: ".",
                    style:
                    Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
