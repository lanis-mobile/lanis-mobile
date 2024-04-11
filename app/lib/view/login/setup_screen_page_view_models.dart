import 'dart:io';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sph_plan/shared/account_types.dart';
import 'package:sph_plan/view/settings/subsettings/notifications.dart';
import 'package:sph_plan/view/settings/subsettings/theme_changer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../client/client.dart';
import '../../shared/apps.dart';
import '../vertretungsplan/filtersettings.dart';

final _klassenStufeController = TextEditingController();
final _klassenController = TextEditingController();
final _lehrerKuerzelController = TextEditingController();

List<PageViewModel> setupScreenPageViewModels(BuildContext context) => [
  //todo @codespoof
  if (client.getAccountType() != AccountType.student)
    PageViewModel(
        image: SvgPicture.asset("assets/undraw/undraw_profile_re_4a55.svg",
            height: 175.0),
        title: AppLocalizations.of(context)!.setupNonStudentTitle,
        body: AppLocalizations.of(context)!.setupNonStudent),
  if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) ...[
    PageViewModel(
        image: SvgPicture.asset("assets/undraw/undraw_filter_re_sa16.svg",
            height: 175.0),
        title: AppLocalizations.of(context)!.setupFilterSubstitutionsTitle,
        body: AppLocalizations.of(context)!.setupFilterSubstitutions),
    PageViewModel(
        image: SvgPicture.asset("assets/undraw/undraw_settings_re_b08x.svg",
            height: 175.0),
        title: AppLocalizations.of(context)!.setupSubstitutionsFilterSettings,
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FilterElements(
              klassenStufeController: _klassenStufeController,
              klassenController: _klassenController,
              lehrerKuerzelController: _lehrerKuerzelController,
            )
          ],
        )),
    if (Platform.isIOS)
      PageViewModel(
          image: SvgPicture.asset(
              "assets/undraw/undraw_new_notifications_re_xpcv.svg",
              height: 175.0),
          title: AppLocalizations.of(context)!.setupPushNotificationsTitle,
          body:
              "Benachrichtigungen werden für dich leider nicht unterstützt, da Apple es nicht ermöglicht, dass Apps periodisch im Hintergrund laufen. Du kannst aber die App öffnen, um zu sehen, ob es neue Vertretungen gibt."),
    if (Platform.isAndroid) ...[
      PageViewModel(
          image: SvgPicture.asset(
              "assets/undraw/undraw_new_notifications_re_xpcv.svg",
              height: 175.0),
          title: AppLocalizations.of(context)!.setupPushNotificationsTitle,
          body: AppLocalizations.of(context)!.setupPushNotifications),
      PageViewModel(
          image: SvgPicture.asset(
              "assets/undraw/undraw_active_options_re_8rj3.svg",
              height: 175.0),
          title: AppLocalizations.of(context)!.setupPushNotificationsTitle,
          bodyWidget: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [NotificationElements()],
          )),
    ]
  ],
  PageViewModel(
      image: SvgPicture.asset("assets/undraw/undraw_add_color_re_buro.svg",
          height: 175.0),
      title: AppLocalizations.of(context)!.appearance,
      bodyWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [AppearanceElements()],
      )),
  PageViewModel(
      image: SvgPicture.asset("assets/undraw/undraw_welcome_re_h3d9.svg",
          height: 175.0),
      title: AppLocalizations.of(context)!.setupReadyTitle,
      body: AppLocalizations.of(context)!.setupReady),
];
