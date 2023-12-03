import 'package:flutter/material.dart';

import '../../client/client.dart';

class MeinUnterrichtAnsicht extends StatefulWidget {
  const MeinUnterrichtAnsicht({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeinUnterrichtAnsichtState();
}

class _MeinUnterrichtAnsichtState extends State<MeinUnterrichtAnsicht> {
  int _currentIndex = 0;

  @override
  void initState() async {
    super.initState();
    //client.getMeinUnterrichtOverview();
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: // Aktuelle Einträge
        return Text('Aktuelle Einträge Content');
      case 1: // Kursmappen
        return Text('Kursmappen Content');
      case 2: //Anwesenheiten
        return Text('Anwesenheiten Content');
      default:
        return Text('Unknown Content');
    }
  }

  @override
  Widget build(BuildContext context) {
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
