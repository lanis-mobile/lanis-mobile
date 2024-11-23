import 'package:flutter/material.dart';
import 'package:sph_plan/applets/substitutions/definition.dart';
import 'package:sph_plan/models/substitution.dart';

import '../../../core/parsers.dart';
import '../../../core/sph/sph.dart';
import '../../../widgets/combined_applet_builder.dart';

class SubstitutionsViewStream extends StatefulWidget {
  const SubstitutionsViewStream({super.key});

  @override
  State<SubstitutionsViewStream> createState() => _SubstitutionsViewStreamState();
}

class _SubstitutionsViewStreamState extends State<SubstitutionsViewStream> {
  @override
  Widget build(BuildContext context) {
    return CombinedAppletBuilder<SubstitutionPlan>(
      accountType: sph!.session.accountType,
      parser: Parsers.substitutionsParser,
      phpUrl: substitutionDefinition.appletPhpUrl,
      settingsDefaults: substitutionDefinition.settings,
      builder: (context, data, accountType, settings, updateSetting) {

        return ListView(
          children: [
            Text(data!.toJson().toString()),
          ],
        );
      },
    );
  }
}