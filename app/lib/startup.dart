import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:sph_plan/home_page.dart';
import 'package:sph_plan/models/client_status_exceptions.dart';
import 'package:sph_plan/utils/logger.dart';
import 'package:sph_plan/view/login/auth.dart';
import 'package:sph_plan/view/login/screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/widgets/offline_available_applets_section.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/database/account_database/account_db.dart';
import 'core/sph/sph.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> with TickerProviderStateMixin{
  LanisException? error;

  // We need to load storage first, so we have to wait before everything.
  ValueNotifier<bool> finishedLoadingStorage = ValueNotifier<bool>(false);

  void openWelcomeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeLoginScreen()),
    );
  }

  void openLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: LoginForm(),
        ),
      ),
    );
  }

  Future<void> performLogin() async {
    logger.i("Performing login...");
    sph?.prefs.close();
    setState(() {
      error = null;
    });
    sph = null;
    final account = await accountDatabase.getLastLoggedInAccount();
    logger.i("Last logged in account: $account");
    if (account != null) {
      sph = SPH(account: account);
    }
    if (sph == null) {
      openWelcomeScreen();
      return;
    }
    await sph?.session.prepareDio();
    logger.i("Prepared Dio for session");
    try {
      logger.i('Authenticating...');
      await sph?.session.authenticate();
      logger.i('Authenticated');

      if (error == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    showIntro: account!.firstLogin,
                  )),
        );
      }
      return;
    } on WrongCredentialsException {
      openWelcomeScreen();
    } on CredentialsIncompleteException {
      openWelcomeScreen();
    } on LanisException catch (e) {
      error = e;
      await showModalBottomSheet(
        context: context,
        builder: (context) => errorDialog(context),
      );
      await performLogin();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      finishedLoadingStorage.value = true;
    });

    super.initState();
    performLogin();
  }

  @override
  void dispose() {
    finishedLoadingStorage.dispose();
    super.dispose();
  }

  Widget appVersion() {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, packageInfo) {
        return Text(
          "lanis-mobile ${packageInfo.data?.version}",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
        );
      },
    );
  }

  Widget appLogo(double horizontal, double vertical) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: LayoutBuilder(builder: (context, constraints) {
        return SimpleShadow(
          color: Theme.of(context).colorScheme.surfaceTint,
          opacity: 0.25,
          sigma: 6,
          offset: const Offset(4, 8),
          child: SvgPicture.asset(
            "assets/startup.svg",
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            fit: BoxFit.contain,
            width: constraints.maxWidth.clamp(0, 300),
            height: constraints.maxHeight.clamp(0, 250),
          ),
        );
      }),
    );
  }

  WidgetSpan toolTipIcon(IconData icon) {
    return WidgetSpan(
        child: Icon(
      icon,
      size: 18,
      color: Theme.of(context).colorScheme.onPrimary,
    ));
  }

  Widget tipText(EdgeInsets padding, EdgeInsets margin, double? width) {
    List<Widget> toolTips = <Widget>[
      Text.rich(TextSpan(
          text: AppLocalizations.of(context)!.startUpMessage1,
          children: [toolTipIcon(Icons.code)])),
      Text.rich(TextSpan(
          text: AppLocalizations.of(context)!.startUpMessage2,
          children: [toolTipIcon(Icons.people)])),
      Text.rich(TextSpan(
          text: AppLocalizations.of(context)!.startUpMessage3,
          children: [toolTipIcon(Icons.filter_alt)])),
      Text.rich(TextSpan(
          text: AppLocalizations.of(context)!.startUpMessage4,
          children: [toolTipIcon(Icons.star)])),
      Text(AppLocalizations.of(context)!.startUpMessage5),
      Text(AppLocalizations.of(context)!.startUpMessage6),
      Text.rich(TextSpan(
          text: AppLocalizations.of(context)!.startUpMessage7,
          children: [toolTipIcon(Icons.favorite)])),
      Text.rich(TextSpan(
          text: AppLocalizations.of(context)!.startUpMessage8,
          children: [toolTipIcon(Icons.code)])),
      Text.rich(TextSpan(
          text: AppLocalizations.of(context)!.startUpMessage9,
          children: [toolTipIcon(Icons.settings)])),
    ];

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withAlpha(85),
                blurRadius: 18,
                spreadRadius: 1,
              )
            ],
            borderRadius: BorderRadius.circular(16.0)),
        padding: padding,
        margin: margin,
        width: width,
        child: DefaultTextStyle(
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          textAlign: TextAlign.center,
          child: toolTips.elementAt(Random().nextInt(toolTips.length)),
        ));
  }

  BottomSheet errorDialog(BuildContext context) {
    var text = AppLocalizations.of(context)!.startupError;
    if (error is LanisDownException) {
      text = AppLocalizations.of(context)!.lanisDownError;
    } else if (error is NoConnectionException) {
      text = AppLocalizations.of(context)!.noInternetConnection2;
    }
    return BottomSheet(
      enableDrag: false,
      showDragHandle: false,
      onClosing: () {
        Navigator.of(context).pop();
      },
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: const Icon(Icons.wifi_find_outlined),
                onPressed: (){
                  launchUrl(Uri.parse(
                      "https://info.schulportal.hessen.de/status-des-schulportal-hessen/"));
                },
                tooltip: AppLocalizations.of(context)!.checkStatus,
              ),
              error is NoConnectionException
                  ? const Icon(
                Icons.wifi_off,
                size: 48,
              )
                  : const Icon(
                Icons.error,
                size: 48,
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: (){
                  Navigator.of(context).pop();
                },
                tooltip: AppLocalizations.of(context)!.tryAgain,
              )
            ],
          ),
          SizedBox(height: 12),
          Center(
            child: Text(text),
          ),
          if (error is! NoConnectionException && error is! LanisDownException)
            Text.rich(TextSpan(
                text: AppLocalizations.of(context)!.startupErrorMessage,
                children: [
                  TextSpan(
                      text: "\n\n${error.runtimeType}: ${error?.cause}",
                      style: Theme.of(context).textTheme.labelLarge)
                ])),
          if (error is LanisDownException)
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: AppLocalizations.of(context)!.lanisDownErrorMessage,
                  style: Theme.of(context).textTheme.labelLarge)
            ])),
            Flexible(child: SingleChildScrollView(
              child: OfflineAvailableAppletsSection(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appVersion(),
        Column(
          children: [
            appLogo(80.0, 20.0),
            tipText(
                const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
                const EdgeInsets.symmetric(horizontal: 36.0),
                null)
          ],
        ),
        const LinearProgressIndicator()
      ],
    )
        : Stack(
      alignment: Alignment.topCenter,
      children: [
        appVersion(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                appLogo(0.0, 0.0),
                SizedBox.fromSize(
                  size: const Size(48.0, 0.0),
                ),
                tipText(
                    const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12.0),
                    const EdgeInsets.only(),
                    250)
              ],
            ),
          ],
        ),
        const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [LinearProgressIndicator()],
        )
      ],
    );
  }
}
