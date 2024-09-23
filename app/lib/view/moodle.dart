import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_inapp/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../client/client.dart';
import '../shared/launch_file.dart';

class MoodleWebView extends StatefulWidget {
  const MoodleWebView({super.key});

  @override
  State<MoodleWebView> createState() => _MoodleWebViewState();
}

class _MoodleWebViewState extends State<MoodleWebView> {
  static CookieManager cookieManager = CookieManager.instance();

  ValueNotifier<bool> canGoBack = ValueNotifier(false);
  ValueNotifier<bool> canGoForward = ValueNotifier(false);
  ValueNotifier<int> progressIndicator = ValueNotifier(0);
  ValueNotifier<bool> hideWebView = ValueNotifier(false);
  ValueNotifier<bool> loggedIn = ValueNotifier(false);

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  bool openedSchoolLogin = false;

  @override
  void initState() {
    super.initState();
    cookieManager.deleteAllCookies();

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
                valueListenable: hideWebView,
                builder: (context, hide, _) {
                  return PopScope(
                    canPop: false,
                    onPopInvokedWithResult: (bool res, _) async {
                      if (res) {
                        return;
                      }

                      final canGoBack = await webViewController!.canGoBack();
                      if (canGoBack) {
                        webViewController!.goBack();
                      } else {
                        hideWebView.value = true;
                        Navigator.pop(context);
                      }
                    },
                    child: Visibility(
                      visible: !hide,
                      child: InAppWebView(
                        pullToRefreshController: pullToRefreshController,
                        initialUrlRequest: URLRequest(
                            url: WebUri("https://start.schulportal.hessen.de/${client.schoolID}")),
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
                        onLoadStop: (controller, url) async {
                          pullToRefreshController!.endRefreshing();
                          progressIndicator.value = 0;
                        },
                        onPageCommitVisible: (controller, uri) {
                          if (!loggedIn.value) {
                            if (uri!.rawValue.contains("login")) {
                              controller.evaluateJavascript(
                                  source:
                                  """
                                  setTimeout(function() {
                                    document.querySelector('#username2').value = '${client.username}';
                                  }, 250);
                                  
                                  setTimeout(function() {
                                    document.querySelector('#inputPassword').value = '${client.password}';
                                  }, 250);
                                  
                                  setTimeout(function() {
                                    document.querySelector('#tlogin').click();
                                  }, 250);
                                  """
                              );
                            }
                            
                            if (uri.rawValue.contains("index.php")) {
                              controller.loadUrl(urlRequest: URLRequest(
                                url: WebUri("https://mo${client.schoolID}.schulportal.hessen.de")
                              ));
                            }

                            if (uri.rawValue.contains("mo${client.schoolID}")) {
                              loggedIn.value = true;
                            }
                          }

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
                        onDownloadStartRequest: (controller, request) async {
                          String url = request.url.rawValue;
                          String filename = request.suggestedFilename ?? client.generateUniqueHash(request.url.rawValue);

                          double fileSize = request.contentLength / 1000000;
                          launchFile(context, url,
                              filename, "${fileSize.toStringAsFixed(2)} MB", () {});
                        },
                      ),
                    ),
                  );
                }),
            ValueListenableBuilder(
                valueListenable: loggedIn,
                builder: (context, logged, _) {
                  return Visibility(
                      visible: !logged,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.maxFinite,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  );
                }),
            ValueListenableBuilder(
                valueListenable: loggedIn,
                builder: (context, logged, _) {
                  return Visibility(
                      visible: !logged,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 24,),
                            Text(
                                AppLocalizations.of(context)!.logInTitle,
                              style: Theme.of(context).textTheme.labelLarge,
                            )
                          ],
                        ),
                      )
                  );
                }),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: loggedIn,
          builder: (context, logged, _) {
            return logged == true
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