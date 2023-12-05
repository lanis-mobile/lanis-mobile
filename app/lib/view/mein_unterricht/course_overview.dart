import 'dart:convert';

import 'package:flutter/material.dart';
import '../../client/client.dart';

class CourseOverviewAnsicht extends StatefulWidget {
  final String dataFetchURL; // Add the dataFetchURL property

  const CourseOverviewAnsicht({Key? key, required this.dataFetchURL}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CourseOverviewAnsichtState();
}

class _CourseOverviewAnsichtState extends State<CourseOverviewAnsicht> {
  int _currentIndex = 0;
  bool loading = false;
  dynamic data = {"historie": [], "leistungen": [], "leistungskontrollen": [], "anwesenheiten": [], "name":["Lade..."]};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String url = widget.dataFetchURL;
    debugPrint(url);
    data = await client.getMeinUnterrichtCourseView(url);

    loading = false;
    setState(() {});
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: // historie
        return ListView.builder(
          itemCount: data["historie"].length,
          itemBuilder: (context, index){
            return Card(
              child: ListTile(
                title: Text(data["historie"][index]["title"]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                        visible: data["historie"][index]["markup"] != "",
                        child: Text(data["historie"][index]["markup"])
                    ),
                    Text(data["historie"][index]["presence"], style: const TextStyle(fontWeight: FontWeight.bold),),
                    Text(data["historie"][index]["time"], style: const TextStyle(fontStyle: FontStyle.italic),)
                  ],
                ),
              ),
            );
          });
      case 1: // leistungen
        return Text("nothing");
      case 2: //anwesenheiten
        return Text("nothing²");
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Leistungen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Anwesenheiten',
          )
        ],
      ),
    );
  }
}
