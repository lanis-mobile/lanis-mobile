import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:webview_inapp/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../client/client.dart';
import '../shared/widgets/error_view.dart';

class MoodleWebView extends StatefulWidget {
  const MoodleWebView({super.key});

  @override
  State<MoodleWebView> createState() => _MoodleWebViewState();
}

class _MoodleWebViewState extends State<MoodleWebView> {
  ValueNotifier<bool> canGoBack = ValueNotifier(false);
  ValueNotifier<bool> canGoForward = ValueNotifier(false);
  ValueNotifier<int> progressIndicator = ValueNotifier(0);
  ValueNotifier<bool> hideWebView = ValueNotifier(false);
  ValueNotifier<String?> error = ValueNotifier(null);

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  Future<void> setCookies() async {
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
        value: client.sessionToken!,
        isSecure: true,
        domain: ".hessen.de");
    cookieManager.setCookie(
        url: WebUri("https://schulportal.hessen.de"),
        name: "i",
        value: client.schoolID,
        isSecure: true,
        domain: ".hessen.de");
  }

  @override
  void initState() {
    super.initState();

    if (client.singleSignOnToken == null) {
      error.value = "Der SSO-Token konnte nicht abgerufen werden!";
      hideWebView.value = true;
      return;
    }

    if (client.sessionToken == null) {
      error.value =
      "Der Session-Token der jetzigen Sitzung konnte nicht abgerufen werden!";
      hideWebView.value = true;
      return;
    }

    progressIndicator.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    pullToRefreshController ??= PullToRefreshController(
        settings: PullToRefreshSettings(
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer),
        onRefresh: () async {
          webViewController?.reload();
        });

    pullToRefreshController!.setColor(Theme.of(context).colorScheme.primary);
    pullToRefreshController!
        .setBackgroundColor(Theme.of(context).colorScheme.surfaceContainer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Moodle"),
          leading: IconButton(
              onPressed: () async {
                hideWebView.value = true;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Stack(
          children: [
            ValueListenableBuilder(
                valueListenable: error,
                builder: (context, _error, _) {
                  return _error != null
                      ? ErrorView(error: LanisException(_error), name: "Moodle")
                      : const SizedBox.shrink();
                }),
            FutureBuilder(
                future: setCookies(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox.shrink();
                  }

                  return ValueListenableBuilder(
                      valueListenable: hideWebView,
                      builder: (context, hide, _) {
                        return PopScope(
                          canPop: false,
                          onPopInvoked: (_) async {
                            webViewController!.goBack();
                          },
                          child: Visibility(
                            visible: !hide,
                            child: InAppWebView(
                              pullToRefreshController: pullToRefreshController,
                              initialUrlRequest: URLRequest(
                                  url: WebUri(
                                      "https://mo${client.schoolID}.schulportal.hessen.de")),
                              initialSettings: InAppWebViewSettings(
                                  transparentBackground: true),
                              onWebViewCreated: (controller) {
                                webViewController = controller;
                              },
                              shouldOverrideUrlLoading:
                                  (controller, navigationAction) async {
                                final WebUri uri = navigationAction.request.url!;
                          
                                if (uri.rawValue.contains(
                                        ".schulportal.hessen.de/login/logout.php") ||
                                    uri.rawValue.contains(
                                        ".schulportal.hessen.de/index.php?logout=all")) {
                                  return NavigationActionPolicy.CANCEL;
                                }
                          
                                if (!uri.rawValue
                                    .contains(".schulportal.hessen.de")) {
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
                                    source:
                                        '''document.querySelector("div#user-action-menu a.dropdown-item[href*='/login/logout.php']").style.display = "none";''');
                                controller.evaluateJavascript(
                                    source:
                                        '''document.querySelector("div.navbar li a[href*='index.php?logout=']").style.display = "none";''');
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
                          ),
                        );
                      });
                }),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: error,
          builder: (context, _error, _) {
            return _error == null
                ? Column(
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
                          IconButton(
                              onPressed: () async {
                                if (webViewController != null) {
                                  await Clipboard.setData(ClipboardData(
                                      text: (await webViewController!.getUrl())!
                                          .rawValue));
                                }
                              },
                              icon: const Icon(Icons.link)),
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
                  )
                : const SizedBox.shrink();
          },
        ));
  }
}
