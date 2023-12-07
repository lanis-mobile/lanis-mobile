import 'package:flutter/material.dart';
import '../../client/client.dart';
import 'course_overview.dart';

class MeinUnterrichtAnsicht extends StatefulWidget {
  const MeinUnterrichtAnsicht({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeinUnterrichtAnsichtState();
}

class _MeinUnterrichtAnsichtState extends State<MeinUnterrichtAnsicht> {
  final double padding = 10.0;

  int _currentIndex = 0;
  bool loading = true;
  dynamic data = {"aktuell": [], "anwesenheiten": [], "kursmappen": []};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      loading = true;
    });
    data = await client.getMeinUnterrichtOverview();
    setState(() {
      loading = false;
    });
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: // Aktuelle Einträge
        return ListView.builder(
          itemCount: data["aktuell"].length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding:
                EdgeInsets.only(left: padding, right: padding, bottom: padding),
                child: Card(
                  child: ListTile(
                    title: Text(data["aktuell"][index]["name"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Thema: ${data["aktuell"][index]["thema"]["title"]}"),
                        //TODO implement "inhalt" and "hausaufgaben"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${data["aktuell"][index]["teacher"]["short"]}-${data["aktuell"][index]["teacher"]["name"]}"),
                            Text(data["aktuell"][index]["thema"]["date"])
                          ],
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CourseOverviewAnsicht(dataFetchURL: data["aktuell"][index]["_courseURL"],)),
                      );
                    },
                  ),
                )
            );
          },
        );
      case 1: // Kursmappen
        return ListView.builder(
          itemCount: data["kursmappen"].length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding:
              EdgeInsets.only(left: padding, right: padding, bottom: padding),
              child: Card(
                child: ListTile(
                  title: Text(data["kursmappen"][index]["title"]),
                  subtitle: Text(data["kursmappen"][index]["teacher"]),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CourseOverviewAnsicht(dataFetchURL: data["kursmappen"][index]["_courseURL"],)),
                    );
                  },
                ),
              )
            );
          },
        );
      case 2: // Anwesenheiten
        return ListView.builder(
          itemCount: data["anwesenheiten"].length,
          itemBuilder: (BuildContext context, int index) {
            List<String> keysNotRender = ["Kurs", "Lehrkraft", "_courseURL"];
            List<Widget> rowChildren = [];

            data["anwesenheiten"][index].forEach((key, value){
              if (!keysNotRender.contains(key) && value != "") {
                rowChildren.add(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$key:"),
                      Text(value)
                    ],
                  )
                );
              }
            });

            return Padding(
              padding: EdgeInsets.only(left: padding, right: padding, bottom: padding),
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
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CourseOverviewAnsicht(dataFetchURL: data["anwesenheiten"][index]["_courseURL"],)),
                    );
                  },
                ),
              )
            );
          },
        );
      default:
        return const Text('Unknown Content');
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
      floatingActionButton: FloatingActionButton(
        onPressed: _loadData,
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list),
            selectedIcon: Icon(Icons.list_outlined),
            label: 'Aktuelle Einträge',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_copy),
            selectedIcon: Icon(Icons.folder_copy_outlined),
            label: 'Kursmappen',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            selectedIcon: Icon(Icons.calendar_today_outlined),
            label: 'Anwesenheiten',
          ),
        ],
      ),
    );
  }
}
