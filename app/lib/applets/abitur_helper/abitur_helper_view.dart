import 'package:flutter/material.dart';
import 'package:sph_plan/applets/abitur_helper/definition.dart';

class AbiturHelperView extends StatelessWidget {
  final Function? openDrawerCb;

  const AbiturHelperView({super.key, this.openDrawerCb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: openDrawerCb != null
          ? AppBar(
              title: Text(abiturHelperDefinition.label(context)),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => openDrawerCb!(),
              ),
            )
          : null,
    );
  }
}
