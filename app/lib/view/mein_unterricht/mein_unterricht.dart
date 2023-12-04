import 'dart:convert';

import 'package:flutter/material.dart';
import '../../client/client.dart';

class MeinUnterrichtAnsicht extends StatefulWidget {
  const MeinUnterrichtAnsicht({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeinUnterrichtAnsichtState();
}

class _MeinUnterrichtAnsichtState extends State<MeinUnterrichtAnsicht> {
  int _currentIndex = 0;
  bool loading = true;
  dynamic data = {"aktuell": [], "anwesenheiten": [], "kursmappen": []};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    debugPrint("loading data...");
    data = await client.getMeinUnterrichtOverview();
    debugPrint(jsonEncode(data["anwesenheiten"]));
    loading = false;
    setState(() {});
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: // Aktuelle Einträge
        return ListView.builder(
          itemCount: data["aktuell"].length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
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
              ),
            );
          },
        );
      case 1: // Kursmappen
        return ListView.builder(
          itemCount: data["kursmappen"].length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(data["kursmappen"][index]["title"]),
                subtitle: Text(data["kursmappen"][index]["teacher"]),
              ),
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

            return Card(
              child: ListTile(
                title: Text(data["anwesenheiten"][index]["Kurs"]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rowChildren,
                ),
              ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Aktuelle Einträge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Kursmappen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Anwesenheiten',
          ),
        ],
      ),
    );
  }
}
