import 'dart:convert';

import 'package:flutter/material.dart';
import '../../client/client.dart';

class CourseOverviewAnsicht extends StatefulWidget {
  final String dataFetchURL; // Add the dataFetchURL property

  const CourseOverviewAnsicht({Key? key, required this.dataFetchURL})
      : super(key: key);

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

  Future<void> _loadData() async {
    String url = widget.dataFetchURL;
    data = await client.getMeinUnterrichtCourseView(url);

    loading = false;
    setState(() {});
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
                                child: Text(data["historie"][index]["markup"])),
                            Text(
                              data["historie"][index]["presence"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data["historie"][index]["time"],
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
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
                  return ListTile(
                    title: Text(data["leistungen"][index]["Name"]),
                    subtitle: Text(data["leistungen"][index]["Datum"]),
                    trailing: Text(
                      data["leistungen"][index]["Note"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  );
                })
            : noDataScreen;
      case 2: //anwesenheiten
        return data["anwesenheiten"].lenght != 0
            ? ListView.builder(
                itemCount: data["anwesenheiten"].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data["anwesenheiten"][index]["type"]),
                    trailing: Text(data["anwesenheiten"][index]["count"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0)),
                  );
                },
              )
            : noDataScreen;
      default:
        return const Text("nothing³");
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
            icon: Icon(Icons.list),
            selectedIcon: Icon(Icons.list_outlined),
            label: 'Anwesenheiten',
          )
        ],
      ),
    );
  }
}
