import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/view/mein_unterricht/upload_page.dart';
import '../../client/client.dart';
import '../../shared/launch_file.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/format_text.dart';

class CourseOverviewAnsicht extends StatefulWidget {
  final String dataFetchURL;
  final String title;
  const CourseOverviewAnsicht(
      {super.key, required this.dataFetchURL, required this.title});

  @override
  State<StatefulWidget> createState() => _CourseOverviewAnsichtState();
}

class _CourseOverviewAnsichtState extends State<CourseOverviewAnsicht> {
  static const double padding = 10.0;

  bool checked = false;

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

  Future<void> _loadData({secondTry = false}) async {
    try {
      if (secondTry) {
        await client.login();
      }

      String url = widget.dataFetchURL;
      data = await client.meinUnterricht.getCourseView(url);

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
        Text("Keine Daten gefunden.")
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
                itemCount: data["halbjahr1"].length > 0
                    ? data["historie"].length + 1
                    : data["historie"].length,
                itemBuilder: (context, index) {
                  //last item in list
                  if (index == data["historie"].length) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: padding,
                        right: padding,
                        bottom: padding,
                      ),
                      child: Card(
                        child: ListTile(
                          title: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CourseOverviewAnsicht(
                                            dataFetchURL: data["halbjahr1"][0],
                                            title: widget.title,
                                          )),
                                );
                              },
                              child: const Text("Zu Halbjahr 1",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18))),
                        ),
                      ),
                    );
                  }

                  List<ActionChip> files = [];
                  data["historie"][index]["files"].forEach((file) {
                    files.add(ActionChip(
                      label: Text(file["filename"]),
                      onPressed: () => launchFile(context, file["url"],
                          file["filename"], file["filesize"], () {}),
                    ));
                  });

                  List<Widget> uploads = [];
                  data["historie"][index]["uploads"].forEach((upload) {
                    if (upload["status"] == "open") {
                      uploads.add(Container(
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(20)),
                          height: 40,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FilledButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UploadScreen(
                                            url: upload["link"],
                                            name: upload["name"],
                                            status: "open"),
                                      ),
                                    );
                                    setState(() {
                                      _loadData();
                                    });
                                  },
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 6,
                                    children: [
                                      const Icon(
                                        Icons.upload,
                                        size: 20,
                                      ),
                                      Text(upload["name"]),
                                      if (upload["uploaded"] != null) ...[
                                        Badge(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          label: Text(
                                            upload["uploaded"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                          ),
                                          largeSize: 20,
                                        )
                                      ]
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.0, right: 12.0),
                                child: Text(
                                  upload["date"],
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              )
                            ],
                          )));
                    } else {
                      uploads.add(OutlinedButton(
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadScreen(
                                      url: upload["link"],
                                      name: upload["name"],
                                      status: "closed"),
                                ),
                              ),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            children: [
                              const Icon(
                                Icons.file_upload_off,
                                size: 18,
                              ),
                              Text(upload["name"]),
                              if (upload["uploaded"] != null) ...[
                                Badge(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  label: Text(
                                    upload["uploaded"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                  ),
                                  largeSize: 20,
                                )
                              ]
                            ],
                          )));
                    }
                  });

                  return Padding(
                    padding: EdgeInsets.only(
                      left: padding,
                      right: padding,
                      bottom: index == data["historie"].length - 1 ? 14 : 8,
                    ),
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 4.0),
                                            child: Icon(
                                              Icons.calendar_today,
                                              size: 15,
                                            ),
                                          ),
                                          Text(
                                            data["historie"][index]["time"] ??
                                                "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: data["historie"][index]
                                                    ["presence"] !=
                                                "nicht erfasst" &&
                                            data["historie"][index]
                                                    ["presence"] !=
                                                null,
                                        child: Row(
                                          children: [
                                            Text(
                                              data["historie"][index]
                                                      ["presence"]
                                                  .replaceAll(
                                                      "andere schulische Veranstaltung",
                                                      "a.s.V."),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 4.0),
                                              child: Icon(
                                                Icons.meeting_room,
                                                size: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (data["historie"][index]["title"] !=
                                    null) ...[
                                  Text(data["historie"][index]["title"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                ],
                                if (data["historie"][index]["markup"]
                                    .containsKey("content")) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4),
                                    child: FormattedText(
                                      text: data["historie"][index]["markup"]
                                          ["content"],
                                    ),
                                  ),
                                ],
                                if (data["historie"][index]["markup"]
                                    .containsKey("homework")) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    margin: const EdgeInsets.only(
                                        top: 8, bottom: 4),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12, top: 4, bottom: 4),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: Icon(
                                                      Icons.school,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Hausaufgabe",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge
                                                        ?.copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Checkbox(
                                              value: data["historie"][index][
                                                  "homework-done"], // Set the initial value as needed
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  width: 2),
                                              onChanged: (bool? value) {
                                                try {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Hausaufgabe wird gespeichert..."),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500)));
                                                  client.meinUnterricht
                                                      .setHomework(
                                                          data["historie"]
                                                                  [index]
                                                              ["course-id"],
                                                          data["historie"]
                                                                  [index]
                                                              ["entry-id"],
                                                          value!)
                                                      .then((val) {
                                                    if (val != "1") {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            "Fehler beim Speichern der Hausaufgabe."),
                                                      ));
                                                    } else {
                                                      setState(() {
                                                        data["historie"][index][
                                                                "homework-done"] =
                                                            value;
                                                      });
                                                    }
                                                  });
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        "Fehler beim Speichern der Hausaufgabe."),
                                                  ));
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .cardColor
                                                  .withOpacity(0.85),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          padding: const EdgeInsets.all(12.0),
                                          child: FormattedText(
                                            text: data["historie"][index]
                                                ["markup"]["homework"],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                                Visibility(
                                  visible: files.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Wrap(
                                      spacing: 8,
                                      children: files,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: uploads.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Wrap(
                                      runSpacing: 8,
                                      spacing: 8,
                                      children: uploads,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
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
                        bottom: index == data["leistungskontrollen"].length - 1
                            ? 14
                            : 8,
                      ),
                      child: Card(
                          child: ListTile(
                        title: Text(
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
                  final String? subtitleText = parseString(
                      data["anwesenheiten"][index]["count"])["brackets"];
                  return Padding(
                      padding: EdgeInsets.only(
                        left: padding,
                        right: padding,
                        bottom:
                            index == data["anwesenheiten"].length - 1 ? 14 : 8,
                      ),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            toBeginningOfSentenceCase(
                                    data["anwesenheiten"][index]["type"]) ??
                                "",
                          ),
                          subtitle: subtitleText != null && subtitleText != ""
                              ? Text(subtitleText)
                              : null,
                          trailing: Text(
                              parseString(data["anwesenheiten"][index]
                                  ["count"])["before"]!,
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
          appBar: AppBar(
            title: const Text("Fehler"),
          ),
          body: ErrorView.fromCode(
            data: data,
            name: "einen Kurs",
            fetcher: null,
          ));
    }

    return Scaffold(
      body: _buildBody(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (data["halbjahr1"].length > 0)
            IconButton(
                icon: const Icon(Icons.looks_one_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CourseOverviewAnsicht(
                              dataFetchURL: data["halbjahr1"][0],
                              title: widget.title,
                            )),
                  );
                })
        ],
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
