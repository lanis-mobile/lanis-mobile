import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo){

      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Über SPH-Vertretungsplan")
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Made with love by @alessioc42'),
            onTap: () {
              launchUrl(Uri.parse("https://github.com/alessioC42"));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Made with love by @kurwjan'),
            onTap: () {
              launchUrl(Uri.parse("https://github.com/kurwjan"));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_comment),
            title: const Text('Feature Request / Bug report'),
            onTap: () {
              launchUrl(Uri.parse(
                  "https://github.com/alessioC42/SPH-vertretungsplan/issues/new/choose"));
            },
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Last Release'),
            onTap: () {
              launchUrl(Uri.parse(
                  "https://github.com/alessioC42/SPH-vertretungsplan/releases/latest"));
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('GitHub Repository'),
            onTap: () {
              launchUrl(Uri.parse(
                  "https://github.com/alessioC42/SPH-vertretungsplan"));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Open Source Lizenzen'),
            onTap: () {
              showLicensePage(context: context);
            }
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text("Build Informationen"),
            onTap: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("App Informationen"),
                      content: Text("appName: $appName\npackageName: $packageName\nversion: $version\nbuildNumber: $buildNumber"),
                    );
                  }
              );
            },
          )
        ],
      ),
    );
  }
}
