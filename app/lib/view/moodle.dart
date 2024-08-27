import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../client/client.dart';

class Moodle extends StatefulWidget {
  const Moodle({Key? key}) : super(key: key);

  @override
  _MoodleState createState() => _MoodleState();
}

class _MoodleState extends State<Moodle> {
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();

    String sessionToken = "";
    client.jar.loadForRequest(Uri.parse("https://start.schulportal.hessen.de")).then((cookies) {
      sessionToken = cookies[1].value;
    });

    CookieManager cookieManager = CookieManager.instance();
    cookieManager.deleteAllCookies();

    cookieManager.setCookie(url: WebUri("https://schulportal.hessen.de"), name: "SPH-Session", value: client.singleSignOnToken!, isSecure: true, domain: ".hessen.de");
    cookieManager.setCookie(url: WebUri("https://schulportal.hessen.de"), name: "sid", value: sessionToken, isSecure: true, domain: ".hessen.de");
    cookieManager.setCookie(url: WebUri("https://schulportal.hessen.de"), name: "i", value: "6091", isSecure: true, domain: ".hessen.de");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(),
        initialUrlRequest:
          URLRequest(url: WebUri("https://mo${client.schoolID}.schulportal.hessen.de")),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final WebUri uri = navigationAction.request.url!;

          if (!uri.rawValue.contains(".schulportal.hessen.de")) {
            await launchUrl(uri);

            return NavigationActionPolicy.CANCEL;
          }

          return NavigationActionPolicy.ALLOW;
        },
      )
    );
  }
}
