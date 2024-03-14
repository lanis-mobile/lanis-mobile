import 'package:flutter/material.dart';
import 'node_view.dart';

class DataStorageAnsicht extends StatefulWidget {
  const DataStorageAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _DataStorageAnsichtState();
}

class _DataStorageAnsichtState extends State<DataStorageAnsicht> {



  @override
  Widget build(BuildContext context) {
    return const DataStorageNodeView(nodeID: 0, title: "Datenspeicher");
  }
}

