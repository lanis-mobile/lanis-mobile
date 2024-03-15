import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';

import '../../shared/launch_file.dart';
import '../../shared/widgets/marquee.dart';

class FileListTile extends ListTile {
  final dynamic file;
  final BuildContext context;

  const FileListTile({super.key, required this.context, required this.file});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: MarqueeWidget(child: Text(file.name)),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (file.hinweis != null) Expanded(child: MarqueeWidget(child: Text(file.hinweis!),)) else Text(file.groesse),
          const SizedBox(width: 5),
          Text(file.aenderung),
        ],
      ),
      leading: FileIcon(file.name, ),
      onTap: () => launchFile(context, file.downloadUrl, file.name, file.groesse),
    );
  }
}

class SearchFileListTile extends ListTile {
  final String name;
  final String downloadUrl;
  final BuildContext context;

  const SearchFileListTile({
    super.key,
    required this.context,
    required this.name,
    required this.downloadUrl
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: MarqueeWidget(child: Text(name)),
      leading: FileIcon(name, ),
      onTap: () => launchFile(context, downloadUrl, name, ""),
    );
  }
}