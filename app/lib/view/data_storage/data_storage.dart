import 'package:flutter/material.dart';
import 'package:sph_plan/view/data_storage/root_view.dart';

class DataStorageAnsicht extends StatefulWidget {
  const DataStorageAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _DataStorageAnsichtState();
}

class _DataStorageAnsichtState extends State<DataStorageAnsicht> {



  @override
  Widget build(BuildContext context) {
    return const DataStorageRootView();
  }
}

