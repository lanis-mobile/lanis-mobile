import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:sph_plan/home_page.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:sph_plan/shared/widgets/whats_new.dart';
import 'package:sph_plan/view/login/auth.dart';
import 'package:sph_plan/view/login/screen.dart';

import 'client/client.dart';
import 'client/logger.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  ValueNotifier<bool> noConnection = ValueNotifier<bool>(false);
  //ValueNotifier<bool> isError = ValueNotifier<bool>(false);
  final ValueNotifier<LanisException?> error = ValueNotifier<LanisException?>(null);

  // We need to load storage first, so we have to wait before everything.
  ValueNotifier<bool> finishedLoadingStorage = ValueNotifier<bool>(false);

  void openWelcomeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeLoginScreen()),
    ).then((_) async {
      await client.prepareDio();

      // Context should be mounted
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  void openLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
                  body: LoginForm(
                afterLogin: () async {
                  await client.loadFromStorage();
                  await client.prepareDio();

                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                relogin: true,
              ))),
    );
  }

  Future<void> performLogin() async {
    // Step 1
    // It doesn't show it immediately but a lot faster than before.
    // I think this check is enough.
    await client.prepareDio();
    if (client.username == "") {
      openWelcomeScreen();
      return;
    }

    try {
      await client.login();

      if (error.value == null) {
        whatsNew().then((value) {
          if (value != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReleaseNotesScreen(value)),
            ).then((_) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                ));
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        });
      }
      return;
    } on WrongCredentialsException {
      openWelcomeScreen();
    } on CredentialsIncompleteException {
      openWelcomeScreen();
    } on LanisException catch (e, stack) {
      logger.e(stack.toString());
      if (e is NoConnectionException) {
        noConnection.value = true;
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      client.loadFromStorage().then((_) {
        finishedLoadingStorage.value = true;
        performLogin();
      });
    });

    super.initState();
  }

  /// Either school image or app version.
  Widget schoolLogo() {
    var darkMode = Theme.of(context).brightness == Brightness.dark;

    Widget deviceInfo = FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, packageInfo) {
        return Text(
          "lanis-mobile ${packageInfo.data?.version}",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25)),
        );
      },
    );

    return CachedNetworkImage(
      imageUrl:
          "https://startcache.schulportal.hessen.de/exporteur.php?a=schoollogo&i=${client.schoolID}",
      fadeInDuration: const Duration(milliseconds: 0),
      placeholder: (context, url) => deviceInfo,
      errorWidget: (context, url, error) => deviceInfo,
      imageBuilder: (context, imageProvider) => ColorFiltered(
        colorFilter: darkMode
            ? const ColorFilter.matrix([
                -1, 0, 0, 0,
                255, 0, -1, 0,
                0, 255, 0, 0,
                -1, 0, 255, 0,
                0, 0, 1, 0
              ])
            : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
        child: Image(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
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
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            fit: BoxFit.contain,
            width: constraints.maxWidth.clamp(0, 300),
            height: constraints.maxHeight.clamp(0, 250),
          ),
        );
      }),
    );
  }

  Widget tipText(EdgeInsets padding, EdgeInsets margin, double? width) {
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
        child: Text(
          "Wussten Sie, dass Sie entführt werden, wenn Sie noch keine Bewertung abgegeben haben?",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          textAlign: TextAlign.center,
        ),
    );
  }

  Widget errorButtons() {
    return ValueListenableBuilder(
        valueListenable: error,
        builder: (context, _error, _) {
          if (_error != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: OutlinedButton(
                        onPressed: () async {
                          // Reset
                          error.value = null;
                          noConnection.value = false;

                          await performLogin();
                        },
                        child: const Text("Erneut versuchen")),
                  )
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: MediaQuery.of(context).orientation == Orientation.portrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      schoolLogo(),
                      Column(
                        children: [
                          appLogo(80.0, 20.0),
                          tipText(
                              const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12.0),
                              const EdgeInsets.symmetric(horizontal: 36.0), null)
                        ],
                      ),
                      const LinearProgressIndicator()
                    ],
                  )
                : Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      schoolLogo(),
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
                                  const EdgeInsets.only(), 250)
                            ],
                          ),
                        ],
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [LinearProgressIndicator()],
                      )
                    ],
                  )));
  }
}
