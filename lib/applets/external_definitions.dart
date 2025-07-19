import 'package:flutter/material.dart';
import 'package:lanis/applets/definitions.dart';
import 'package:lanis/core/sph/session.dart';
import 'package:lanis/core/sph/sph.dart';
import 'package:lanis/generated/l10n.dart';
import 'package:lanis/applets/moodle/moodle.dart';
import 'package:url_launcher/url_launcher.dart';

final openLanisDefinition = ExternalDefinition(
    id: 'openLanis',
    label: (context) => AppLocalizations.of(context).openLanisInBrowser,
    action: (_) {
      SessionHandler.getLoginURL(sph!.account).then((response) {
        launchUrl(Uri.parse(response));
      });
    });
