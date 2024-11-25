import 'package:flutter/material.dart';

import 'package:sph_plan/view/settings/info_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/sph/sph.dart';

class SupportedFeaturesOverviewScreen extends StatefulWidget {
  const SupportedFeaturesOverviewScreen({super.key});

  @override
  State<StatefulWidget> createState() =>
      _SupportedFeaturesOverviewScreenState();
}

class _SupportedFeaturesOverviewScreenState
    extends State<SupportedFeaturesOverviewScreen> {
  double padding = 10.0;

  List<ListTile> featureListListTiles = [];

  @override
  void initState() {
    super.initState();
    loadFeatureData();
  }

  void loadFeatureData() {
    setState(() {
      featureListListTiles.clear();

      for (var value in sph!.session.travelMenu) {
        featureListListTiles.add(ListTile(
          leading: const Icon(Icons.settings_applications),
          iconColor: HexColor.fromHex(value["Farbe"]),
          title: Text(value["Name"]),
          subtitle: Text('#TODO'),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.personalSchoolSupport),
        actions: [
          InfoButton(
              infoText: AppLocalizations.of(context)!
                  .settingsInfoPersonalSchoolSupport,
              context: context)
        ],
      ),
      body: ListView(
        children: featureListListTiles,
      ),
    );
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
