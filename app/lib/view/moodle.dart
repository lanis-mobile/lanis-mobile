import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io' as io;

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
  ValueNotifier<String> currentPageTitle = ValueNotifier("");


  String? error;
  WebUri? errorUrl;
  bool errorDuringLogin = false;

  bool reachedLogin = false;

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  io.Cookie translateCookie(Cookie cookie) {
    var target = io.Cookie(cookie.name, cookie.value);
    target.domain = cookie.domain;
    target.path = cookie.path;
    target.secure = cookie.isSecure!;
    target.httpOnly = cookie.isHttpOnly!;

    return target;
  }

  void refresh() {
    if (webViewController != null) {
      if (errorDuringLogin) {
        errorDuringLogin = false;
        loggedIn.value = false;
      }

      if (error != null) {
        webViewController!.loadUrl(urlRequest: URLRequest(
            url: errorUrl
        ));

        error = null;
        errorUrl = null;

        return;
      }

      webViewController!.reload();
    }
  }

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
        onRefresh: refresh);

    pullToRefreshController!.setColor(Theme.of(context).colorScheme.primary);
    pullToRefreshController!
        .setBackgroundColor(Theme.of(context).colorScheme.surfaceContainer);
  }

  /// replaces ' with \'
  String _sanitizeCredentialsForJavaScript(String source) {
    return source.replaceAll("'", "\\'");
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
            if (error != null) ...[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, size: 60,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                          AppLocalizations.of(context)!.errorOccurredWebsite,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              child: Text(
                                AppLocalizations.of(context)!.error,
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Flexible(
                            child: Text(
                              error ?? "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 4,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              child: Text(
                                "URL",
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Flexible(
                            child: Text(
                              errorUrl?.rawValue ?? "Unknown error",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                            url: WebUri("https://mo${client.schoolID}.schulportal.hessen.de")),
                        initialSettings: InAppWebViewSettings(
                            transparentBackground: true,
                          disableDefaultErrorPage: true
                        ),
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

                          if (reachedLogin && uri.rawValue.contains('start.schulportal.hessen.de')) {
                            hideWebView.value = true;
                            Navigator.pop(context);
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
                        onTitleChanged: (controller, title) {
                          currentPageTitle.value = title ?? "";
                        },
                        onPageCommitVisible: (controller, uri) async {
                          if (!loggedIn.value) {
                            if (!reachedLogin && uri!.rawValue.contains("singleSignOn") && !uri.rawValue.contains(client.schoolID)) {
                              controller.loadUrl(
                                  urlRequest: URLRequest(
                                      url: WebUri("${uri.rawValue}&i=${client.schoolID}")
                                  )
                              );
                              reachedLogin = true;
                            }

                            if (reachedLogin) {
                              controller.evaluateJavascript(
                                  source:
                                  """
                                  setTimeout(function() {
                                    document.querySelector('#username2').value = '${_sanitizeCredentialsForJavaScript(client.username)}';
                                  }, 250);
                                  
                                  setTimeout(function() {
                                    document.querySelector('#inputPassword').value = '${_sanitizeCredentialsForJavaScript(client.password)}';
                                  }, 250);
                                  
                                  setTimeout(function() {
                                    document.querySelector('#tlogin').click();
                                  }, 250);
                                """
                              );
                            }

                            if (reachedLogin && uri!.rawValue.contains("mo${client.schoolID}")) {
                              loggedIn.value = true;

                              List<io.Cookie> cookies = [
                                translateCookie((await cookieManager.getCookie(url: WebUri("https://mo${client.schoolID}.schulportal.hessen.de"), name: "MoodleSession"))!),
                                translateCookie((await cookieManager.getCookie(url: WebUri("https://mo${client.schoolID}.schulportal.hessen.de"), name: "MOODLEID1_"))!),
                                translateCookie((await cookieManager.getCookie(url: WebUri("https://mo${client.schoolID}.schulportal.hessen.de"), name: "mo-prod01"))!)
                              ];

                              await client.jar.saveFromResponse(
                                  Uri.parse("https://mo${client.schoolID}.schulportal.hessen.de"),
                                  cookies
                              );
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
                        onReceivedError: (controller, request, response) {
                          setState(() {
                            error = response.description;
                            errorUrl = request.url;
                          });

                          if (loggedIn.value == false) {
                            errorDuringLogin = true;
                            loggedIn.value = true;
                          }

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
                        onPressed: refresh,
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
                    Expanded(
                      child: Center(
                          child: ValueListenableBuilder(valueListenable: currentPageTitle, builder: (context, title, _) =>
                              Text(title,
                                style: Theme.of(context).textTheme.labelLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                          )
                      ),
                    ),
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
