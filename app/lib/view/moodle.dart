import 'package:flutter/material.dart';
import 'package:webview_inapp/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../client/client.dart';

class MoodleWebView extends StatefulWidget {
  const MoodleWebView({super.key});

  @override
  State<MoodleWebView> createState() => _MoodleWebViewState();
}

class _MoodleWebViewState extends State<MoodleWebView> {
  ValueNotifier<bool> canGoBack = ValueNotifier(false);
  ValueNotifier<bool> canGoForward = ValueNotifier(false);
  ValueNotifier<int> progressIndicator = ValueNotifier(0);

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    String sessionToken = "";
    client.jar
        .loadForRequest(Uri.parse("https://start.schulportal.hessen.de"))
        .then((cookies) {
      sessionToken = cookies[1].value;
    });

    CookieManager cookieManager = CookieManager.instance();
    cookieManager.deleteAllCookies();

    cookieManager.setCookie(
        url: WebUri("https://schulportal.hessen.de"),
        name: "SPH-Session",
        value: client.singleSignOnToken!,
        isSecure: true,
        domain: ".hessen.de");
    cookieManager.setCookie(
        url: WebUri("https://schulportal.hessen.de"),
        name: "sid",
        value: sessionToken,
        isSecure: true,
        domain: ".hessen.de");
    cookieManager.setCookie(
        url: WebUri("https://schulportal.hessen.de"),
        name: "i",
        value: "6091",
        isSecure: true,
        domain: ".hessen.de");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    pullToRefreshController ??= PullToRefreshController(
        settings: PullToRefreshSettings(
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer
        ),
          onRefresh: () async {
            webViewController?.reload();
          });

    pullToRefreshController!.setColor(Theme.of(context).colorScheme.primary);
    pullToRefreshController!.setBackgroundColor(Theme.of(context).colorScheme.surfaceContainer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moodle"),
        actions: [
          IconButton(
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse("moodlemobile://https://${client.username}@mo${client.schoolID}.schulportal.hessen.de"))) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          icon: const Icon(Icons.warning),
                          title: Text("In der Moodle App öffnen"),
                          content: Text("Möglicherweise könnte deine Schule inkompatibel mit der App sein!"),
                          actions: [
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(AppLocalizations.of(context)!.back)
                            ),
                            FilledButton(
                                onPressed: () {
                                  launchUrl(Uri.parse("moodlemobile://https://${client.username}@mo${client.schoolID}.schulportal.hessen.de"));
                                  Navigator.of(context).pop();
                                },
                                child: Text(AppLocalizations.of(context)!.actionContinue)
                            )
                          ],
                        );
                      }
                  );
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          icon: const Icon(Icons.exit_to_app),
                          title: Text("In der Moodle App öffnen"),
                          content: Text("Die Moodle App ist genauso wie lanis-mobile für mobile Endgeräte optimiert. Installiere die App und komme wieder hierher, um direkt zum Login geschickt zu werden."),
                          actions: [
                            TextButton(
                                onPressed: () { launchUrl(Uri.parse("https://apps.apple.com/de/app/moodle/id633359593")); },
                                child: const Text("App Store")
                            ),
                            TextButton(
                                onPressed: () { launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.moodle.moodlemobile")); },
                                child: const Text("Play Store")
                            ),
                            FilledButton(
                                onPressed: () { Navigator.of(context).pop(); },
                                child: Text(AppLocalizations.of(context)!.back)
                            ),
                          ],
                        );
                      });
                }

                },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            pullToRefreshController: pullToRefreshController,
            initialUrlRequest: URLRequest(
                url: WebUri(
                    "https://mo${client.schoolID}.schulportal.hessen.de")),
            initialSettings: InAppWebViewSettings(transparentBackground: true),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final WebUri uri = navigationAction.request.url!;

              if (uri.rawValue.contains(".schulportal.hessen.de/login/logout.php") || uri.rawValue.contains(".schulportal.hessen.de/index.php?logout=all")) {
                return NavigationActionPolicy.CANCEL;
              }

              if (!uri.rawValue.contains(".schulportal.hessen.de")) {
                await launchUrl(uri);

                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
            onLoadStart: (controller, uri) async {
              if (await controller.canGoBack()) {
                canGoBack.value = true;
              } else {
                canGoBack.value = false;
              }

              if (await controller.canGoForward()) {
                canGoForward.value = true;
              } else {
                canGoForward.value = false;
              }
            },
            onLoadStop: (controller, url) {
              pullToRefreshController!.endRefreshing();
              progressIndicator.value = 0;
            },
            onPageCommitVisible: (controller, uri) {
              // Hack to enable pull to refresh in Moodle.
              controller.evaluateJavascript(
                  source:
                  "document.documentElement.style.height = document.documentElement.clientHeight + 1 + 'px';");

              // Hide logout buttons.
              controller.evaluateJavascript(
                  source: '''document.querySelector("div#user-action-menu a.dropdown-item[href*='/login/logout.php']").style.display = "none";'''
              );
              controller.evaluateJavascript(
                  source: '''document.querySelector("div.navbar li a[href*='index.php?logout=']").style.display = "none";'''
              );
            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
                pullToRefreshController!.endRefreshing();
                progressIndicator.value = 0;
                return;
              }

              progressIndicator.value = progress;
            },
            onReceivedError: (controller, request, error) {
              pullToRefreshController!.endRefreshing();
              progressIndicator.value = 0;
            },
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
              valueListenable: progressIndicator,
              builder: (context, progress, _) {
                return Visibility(
                  visible: progress != 0,
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  child: LinearProgressIndicator(
                    value: progress / 100,
                  ),
                );
              }),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (webViewController != null) {
                      webViewController!.reload();
                    }
                  },
                  icon: const Icon(Icons.refresh)),
              const Spacer(),
              ValueListenableBuilder(
                  valueListenable: canGoBack,
                  builder: (context, can, _) {
                    return IconButton(
                        onPressed: can
                            ? () {
                                webViewController?.goBack();
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back));
                  }),
              ValueListenableBuilder(
                  valueListenable: canGoForward,
                  builder: (context, can, _) {
                    return IconButton(
                        onPressed: can
                            ? () {
                                webViewController?.goForward();
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward));
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
