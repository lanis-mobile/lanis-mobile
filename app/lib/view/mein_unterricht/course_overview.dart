
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../client/client.dart';

class CourseOverviewAnsicht extends StatefulWidget {
  final String dataFetchURL; // Add the dataFetchURL property

  const CourseOverviewAnsicht({super.key, required this.dataFetchURL});

  @override
  State<StatefulWidget> createState() => _CourseOverviewAnsichtState();
}

class _CourseOverviewAnsichtState extends State<CourseOverviewAnsicht> {
  final double padding = 10.0;

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
                        left: padding, right: padding, bottom: padding),
                    child: Card(
                      child: ListTile(
                        title: Text(data["historie"][index]["title"]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                                visible:
                                    data["historie"][index]["markup"] != "",
                                child: Linkify(
                                  onOpen: (link) async {
                                    if (!await launchUrl(Uri.parse(link.url))) {
                                      debugPrint("${link.url} konnte nicht geöffnet werden.");
                                    }
                                  },
                                  text: data["historie"][index]["markup"],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  linkStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Theme.of(context).colorScheme.primary),
                                ),
                            ),
                            Text(
                              data["historie"][index]["presence"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data["historie"][index]["time"],
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                            Wrap(
                              spacing: 8,
                              children: files,
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
                        left: padding, right: padding, bottom: padding),
                    child: Card(
                      child: ListTile(
                        title: Text(data["leistungen"][index]["Name"]),
                        subtitle: Text(data["leistungen"][index]["Datum"]),
                        trailing: Text(
                          data["leistungen"][index]["Note"],
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
                          left: padding, right: padding, bottom: padding),
                      child: Card(
                          child: ListTile(
                        title:
                            Text(data["leistungskontrollen"][index]["title"]),
                        subtitle: Text(
                          data["leistungskontrollen"][index]["value"],
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
                  return Padding(
                      padding: EdgeInsets.only(
                          left: padding, right: padding, bottom: padding),
                      child: Card(
                        child: ListTile(
                          title: Text(data["anwesenheiten"][index]["type"]),
                          trailing: Text(data["anwesenheiten"][index]["count"],
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: _buildBody(),
      appBar: AppBar(
        title: Text(data["name"][0]),
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
