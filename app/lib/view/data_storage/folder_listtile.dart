import 'package:flutter/material.dart';
import 'package:sph_plan/shared/types/dateispeicher_node.dart';

import 'node_view.dart';


class FolderListTile extends ListTile {
  final FolderNode folder;
  final BuildContext context;

  const FolderListTile({super.key, required this.context, required this.folder});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(folder.name),
        subtitle: Text(folder.desc, maxLines: 2, overflow: TextOverflow.ellipsis,),
        leading: const Icon(Icons.folder_outlined),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DataStorageNodeView(nodeID: folder.id, title: folder.name),
            ),
          );
        }
    );
  }
}