import 'package:flutter/material.dart';
import 'package:sph_plan/applets/abitur_helper/definition.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';

class AbiturHelperView extends StatelessWidget {
  final Function? openDrawerCb;

  const AbiturHelperView({super.key, this.openDrawerCb});

  @override
  Widget build(BuildContext context) {
    return CombinedAppletBuilder(
        parser: sph!.parser.abiturParser,
        phpUrl: abiturHelperDefinition.appletPhpUrl,
        settingsDefaults: abiturHelperDefinition.settingsDefaults,
        accountType: sph!.session.accountType,
        showErrorAppBar: true,
        loadingAppBar: AppBar(),
        builder:
            (context, data, accountType, settings, updateSetting, refresh) {
          return Placeholder();
        });
  }
}
