import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import '../../client/client.dart';
import '../../shared/errorView.dart';
import '../../shared/styledTextWidget.dart';

class CourseOverviewAnsicht extends StatefulWidget {
  final String dataFetchURL; // Add the dataFetchURL property
  final String title;
  const CourseOverviewAnsicht({super.key, required this.dataFetchURL, required this.title});

  @override
  State<StatefulWidget> createState() => _CourseOverviewAnsichtState();
}

class _CourseOverviewAnsichtState extends State<CourseOverviewAnsicht> {
  static const double padding = 10.0;

  int _currentIndex = 0;
  bool loading = true;
  dynamic data = {
    "historie": [],
    "leistungen": [],
    "leistungskontrollen": [],
    "anwesenheiten": [],
    "name": ["Lade..."]
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({secondTry= false}) async {
    try {
      if (secondTry) {
        await client.login();
      }

      String url = widget.dataFetchURL;
      data = await client.getMeinUnterrichtCourseView(url);

      loading = false;
      setState(() {});
    } catch (e) {
      if (!secondTry) {
        _loadData(secondTry: true);
      }
    }
  }

  final Widget noDataScreen = const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.search,
          size: 60,
        ),
        Text("Keine Daten hinterlegt.")
      ],
    ),
  );

  Widget _buildBody() {
    if (data is int && data < 0) {
      return noDataScreen;
    }

    switch (_currentIndex) {
      case 0: // historie
        return data["historie"].length != 0
            ? ListView.builder(
                itemCount: data["historie"].length,
                itemBuilder: (context, index) {
                  List<ActionChip> files = [];
                  data["historie"][index]["files"].forEach((file) {
                    files.add(ActionChip(
                      label: Text(file["filename"]),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Download... ${file['filesize']}"),
                                content: const Center(
                                  heightFactor: 1.1,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            });
                        client.downloadFile(file["url"], file["filename"]).then((filepath) {
                          Navigator.of(context).pop();

                          if (filepath == "") {
                            showDialog(context: context, builder: (context) => AlertDialog(
                              title: const Text("Fehler!"),
                              content: Text("Beim Download der Datei ${file["filename"]} ist ein unerwarteter Fehler aufgetreten. Wenn dieses Problem besteht, senden Sie uns bitte einen Fehlerbericht."),
                              actions: [TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),],
                            ));
                          } else {
                            OpenFile.open(filepath);
                          }
                        });
                      },
                    ));
                  });

                  return Padding(
                    padding: EdgeInsets.only(
                      left: padding,
                      right: padding,
                      bottom: index == data["historie"].length - 1 ? 14 : 8,
                    ),
                    child: Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: (data["historie"][index]["title"]  != null) ? Text(
                            data["historie"][index]["title"],
                          style: Theme.of(context).textTheme.titleLarge,
                        ) : null,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                                visible:
                                    data["historie"][index]["markup"] != "",
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                                  child: FormattedText(text: data["historie"][index]["markup"],),
                                )
                            ),
                            Visibility(
                              visible: data["historie"][index]["presence"] != "nicht erfasst" && data["historie"][index]["presence"] != null,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2, bottom: 2),
                                child: Text(
                                  data["historie"][index]["presence"],
                                  style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              data["historie"][index]["time"] ?? "",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Visibility(
                              visible: files.isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(top: padding),
                                child: Wrap(
                                  spacing: 8,
                                  children: files,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : noDataScreen;
      case 1: // leistungen
        return data["leistungen"].length != 0
            ? ListView.builder(
                itemCount: data["leistungen"].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: padding,
                      right: padding,
                      bottom: index == data["leistungen"].length - 1 ? 14 : 8,
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(
                            data["leistungen"][index]["Name"] ?? "",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                            data["leistungen"][index]["Datum"] ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: Text(
                          data["leistungen"][index]["Note"] ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                    ),
                  );
                },
              )
            : noDataScreen;
      case 2: //Leistungskontrollen
        return data["leistungskontrollen"].length != 0
            ? ListView.builder(
                itemCount: data["leistungskontrollen"].length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.only(
                        left: padding,
                        right: padding,
                        bottom: index == data["leistungskontrollen"].length - 1 ? 14 : 8,
                      ),
                      child: Card(
                          child: ListTile(
                        title:
                            Text(
                                data["leistungskontrollen"][index]["title"] ?? "",
                                    style: Theme.of(context).textTheme.titleMedium,
                            ),
                        subtitle: Text(
                          data["leistungskontrollen"][index]["value"] ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )));
                },
              )
            : noDataScreen;
      case 3: //anwesenheiten
        return data["anwesenheiten"].length != 0
            ? ListView.builder(
                itemCount: data["anwesenheiten"].length,
                itemBuilder: (context, index) {
                  final String? subtitleText = parseString(data["anwesenheiten"][index]["count"])["brackets"];
                  return Padding(
                      padding: EdgeInsets.only(
                        left: padding,
                        right: padding,
                        bottom: index == data["anwesenheiten"].length - 1 ? 14 : 8,
                      ),
                      child: Card(
                        child: ListTile(
                          title: Text(toBeginningOfSentenceCase(data["anwesenheiten"][index]["type"]) ?? "",),
                          subtitle: subtitleText != null && subtitleText != "" ? Text(subtitleText) : null,
                          trailing: Text(parseString(data["anwesenheiten"][index]["count"])["before"]!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0)),
                        ),
                      ));
                },
              )
            : noDataScreen;
      default:
        return const Text("das hätte nicht passieren sollen!");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (data is int && data < 0) {
      return Scaffold(
        appBar: AppBar(title: const Text("Fehler"),),
        body: ErrorView(data: data, name: "einen Kurs", fetcher: null,)
      );
    }

    return Scaffold(
      body: _buildBody(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history_outlined),
            label: 'Historie',
          ),
          NavigationDestination(
            icon: Icon(Icons.star),
            selectedIcon: Icon(Icons.star_outline),
            label: 'Leistungen',
          ),
          NavigationDestination(
              icon: Icon(Icons.draw),
              selectedIcon: Icon(Icons.draw_outlined),
              label: "Klausuren"),
          NavigationDestination(
            icon: Icon(Icons.list),
            selectedIcon: Icon(Icons.list_outlined),
            label: 'Anwesenheiten',
          )
        ],
      ),
    );
  }
}

Map<String, String> parseString(String input) {
  RegExp regex = RegExp(r'(\d+)\s*(?:\(([^)]*)\))?');
  RegExpMatch? match = regex.firstMatch(input);

  if (match != null) {
    String before = match.group(1) ?? "";
    String brackets = match.group(2) ?? "";
    return {"before": before, "brackets": brackets};
  }

  return {"before": "", "brackets": ""};
}
