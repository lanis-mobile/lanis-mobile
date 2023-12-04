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
  String gURL = "";
  dynamic data = {"historie": [], "leistungen": [], "leistungskontrollen": [], "anwesenheiten": []};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String url = widget.dataFetchURL;
    //load data
    gURL = url;

    loading = false;
    setState(() {});
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: // historie
        return Text(gURL);
      case 1: // leistungen
        return Text(gURL);
      case 2: // leistungskontrollen
        return Text(gURL);
      case 3: // Anwesenheiten
        return Text(gURL);
      default:
        return Text(gURL);
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
        title: Text("kursname"),
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
