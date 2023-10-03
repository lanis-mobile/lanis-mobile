import 'package:flutter/material.dart';

import 'filterlogic.dart';

class FilterPlan extends StatelessWidget {
  FilterPlan({super.key}) {
    loadConfiguration();
  }

  final _klassenStufeController = TextEditingController();
  final _klassenController = TextEditingController();
  final _lehrerKuerzelController = TextEditingController();

  void loadConfiguration() async {
    final filterQueries = await getFilter();

    _klassenStufeController.text = filterQueries["klassenStufe"];
    _klassenController.text = filterQueries["klasse"];
    _lehrerKuerzelController.text = filterQueries["lehrerKuerzel"];
  }

  @override
  Widget build(BuildContext context) {
    double padding = 10.0;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Filter anpassen'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextFormField(
                  controller: _klassenStufeController,
                  decoration: const InputDecoration(
                      labelText: 'Klassenstufe (e.g. 7; 8; E; Q)')),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextFormField(
                  controller: _klassenController,
                  decoration: const InputDecoration(
                      labelText: 'Klasse (e.g. a; b; c; 1/2; 3/4)')),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextFormField(
                  controller: _lehrerKuerzelController,
                  decoration: const InputDecoration(
                      labelText: 'Lehrerkürzel (e.g. Abc; Müller)')),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: ElevatedButton(
                onPressed: () async {
                  await setFilter(
                          _klassenStufeController.text,
                          _klassenController.text,
                          _lehrerKuerzelController.text)
                      .then((_) {
                    Navigator.pop(context);
                  });
                },
                child: const Text('Anwenden'),
              ),
            ),
          ],
        ));
  }
}
