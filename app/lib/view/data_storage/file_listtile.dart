import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';

import '../../client/client.dart';
import '../../shared/launch_file.dart';
import '../../shared/widgets/marquee.dart';

enum FileExists { yes, no, loading }

extension FileExistsExtension on FileExists {
  MaterialColor? get color => {
        FileExists.yes: Colors.green,
        FileExists.no: Colors.red,
        FileExists.loading: Colors.grey,
      }[this];
}

class FileListTile extends StatefulWidget {
  final dynamic file;
  final BuildContext context;

  const FileListTile({super.key, required this.context, required this.file});

  @override
  _FileListTileState createState() => _FileListTileState();
}

class _FileListTileState extends State<FileListTile> {
  var exists = FileExists.loading;

  @override
  void initState() {
    super.initState();
    updateLocalFileStatus();
  }

  void updateLocalFileStatus() {
    client
        .doesFileExist(widget.file.downloadUrl, widget.file.name)
        .then((value) {
      setState(() {
        exists = value ? FileExists.yes : FileExists.no;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: MarqueeWidget(child: Text(widget.file.name)),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.file.hinweis != null)
            Expanded(
                child: MarqueeWidget(
              child: Text(widget.file.hinweis!),
            ))
          else
            Text(widget.file.groesse),
          const SizedBox(width: 5),
          Text(widget.file.aenderung),
        ],
      ),
      leading: Badge(
          backgroundColor: exists.color,
          child: FileIcon(
            widget.file.name,
          )),
      onTap: () => launchFile(context, widget.file.downloadUrl,
          widget.file.name, widget.file.groesse, updateLocalFileStatus),
    );
  }
}

class SearchFileListTile extends StatefulWidget {
  final String name;
  final String downloadUrl;
  final BuildContext context;

  const SearchFileListTile(
      {Key? key,
      required this.context,
      required this.name,
      required this.downloadUrl})
      : super(key: key);

  @override
  _SearchFileListTileState createState() => _SearchFileListTileState();
}

class _SearchFileListTileState extends State<SearchFileListTile> {
  var exists = FileExists.loading;

  @override
  void initState() {
    super.initState();
    updateLocalFileStatus();
  }

  void updateLocalFileStatus() {
    client.doesFileExist(widget.downloadUrl, widget.name).then((value) {
      setState(() {
        exists = value ? FileExists.yes : FileExists.no;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: MarqueeWidget(child: Text(widget.name)),
      leading: Badge(
        backgroundColor: exists.color,
        child: FileIcon(widget.name),
      ),
      onTap: () => launchFile(
          context, widget.downloadUrl, widget.name, "", updateLocalFileStatus),
    );
  }
}
