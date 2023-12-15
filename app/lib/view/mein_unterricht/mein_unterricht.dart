import 'package:flutter/material.dart';
import '../../client/client.dart';
import 'course_overview.dart';

class MeinUnterrichtAnsicht extends StatefulWidget {
  const MeinUnterrichtAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _MeinUnterrichtAnsichtState();
}

class _MeinUnterrichtAnsichtState extends State<MeinUnterrichtAnsicht> with TickerProviderStateMixin {
  final double padding = 8.0;
  late TabController _tabController;

  bool loading = true;
  dynamic data = {"aktuell": [], "anwesenheiten": [], "kursmappen": []};

  @override
  void initState() {
    super.initState();
    _loadData();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData({secondTry= false}) async {
    try {
      setState(() {
        loading = true;
      });
      if (secondTry) {
        await client.login();
      }

      data = await client.getMeinUnterrichtOverview();

      setState(() {
        loading = false;
      });
    } catch (e) {
      if (!secondTry) {
        _loadData(secondTry: true);
      }
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
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.list),
                  text: "Aktuelles",
                ),
                Tab(
                  icon: Icon(Icons.folder_copy),
                  text: "Kursmappen"
                ),
                Tab(
                  icon: Icon(Icons.calendar_today),
                  text: "Anwesenheiten",
                )
              ]
          ),
          Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                    itemCount: data["aktuell"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.only(
                              left: padding, right: padding, bottom: padding),
                          child: Card(
                            child: ListTile(
                              title: Text(data["aktuell"][index]["name"]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Thema: ${data["aktuell"][index]["thema"]["title"]}"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${data["aktuell"][index]["teacher"]["short"]}-${data["aktuell"][index]["teacher"]["name"]}"),
                                      Text(data["aktuell"][index]["thema"]["date"])
                                    ],
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CourseOverviewAnsicht(
                                        dataFetchURL: data["aktuell"][index]
                                        ["_courseURL"],
                                      )),
                                );
                              },
                            ),
                          ));
                    },
                  ),
                  ListView.builder(
                    itemCount: data["kursmappen"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.only(
                              left: padding, right: padding, bottom: padding),
                          child: Card(
                            child: ListTile(
                              title: Text(data["kursmappen"][index]["title"]),
                              subtitle: Text(data["kursmappen"][index]["teacher"]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CourseOverviewAnsicht(
                                        dataFetchURL: data["kursmappen"][index]
                                        ["_courseURL"],
                                      )),
                                );
                              },
                            ),
                          ));
                    },
                  ),
                  ListView.builder(
                    itemCount: data["anwesenheiten"].length,
                    itemBuilder: (BuildContext context, int index) {
                      List<String> keysNotRender = ["Kurs", "Lehrkraft", "_courseURL"];
                      List<Widget> rowChildren = [];

                      data["anwesenheiten"][index].forEach((key, value) {
                        if (!keysNotRender.contains(key) && value != "") {
                          rowChildren.add(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("$key:"), Text(value)],
                          ));
                        }
                      });

                      return Padding(
                          padding: EdgeInsets.only(
                              left: padding, right: padding, bottom: padding),
                          child: Card(
                            child: ListTile(
                              title: Text(data["anwesenheiten"][index]["Kurs"]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: rowChildren,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CourseOverviewAnsicht(
                                        dataFetchURL: data["anwesenheiten"][index]
                                        ["_courseURL"],
                                      )),
                                );
                              },
                            ),
                          ));
                    },
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}
