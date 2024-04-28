import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chips_input/chips_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../client/client.dart';
import '../../client/client_submodules/substitutions.dart';

EntryFilter parseEntryFilter(Map<String, dynamic> json) {
  return json.map((key, value) {
    if (value is bool) {
      return MapEntry(key, value);
    } else if (value is List<dynamic>) {
      return MapEntry(key, List<String>.from(value));
    } else {
      throw Exception('Unexpected type for value in EntryFilter');
    }
  });
}

class FilterSettingsScreen extends StatefulWidget {
  const FilterSettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FilterSettingsScreenState();
}

class _FilterSettingsScreenState extends State<FilterSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Vertretungsplan Filter"),
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      client.substitutions.localFilter = {};
                      client.substitutions.saveFilterToStorage();
                      Navigator.pop(context);
                    },
                    child: const Text("Zurücksetzen")),
                ElevatedButton(
                    onPressed: () async {
                      final dio = Dio();
                      final response = await dio.post(
                        "https://lanis-mobile-api.alessioc42.workers.dev/api/filter/generate",
                        options: Options(
                          headers: {
                            "Content-type": "application/json",
                          },
                        ),
                        data: jsonEncode({
                          "schoolID": client.schoolID,
                          "loginName": client.username,
                          "classString": client.userData["klasse"]??"",
                          "classLevel": client.userData["stufe"]??""
                        })
                      );
                      final data = jsonDecode(response.toString());
                      if (data["success"]) {
                        final filterResponse = data["result"]["task"];
                        client.substitutions.localFilter = Map<String, EntryFilter>.from(filterResponse).map((key, value) {
                          return MapEntry(key, parseEntryFilter(Map<String, dynamic>.from(value)));
                        });
                        client.substitutions.saveFilterToStorage();
                        Navigator.pop(context);
                      } else {
                        throw UnimplementedError();
                      }
                    },
                    child: const Text("Automatisch Festlegen")),
              ],
            ),
            const SubstitutionFilterEditor(objKey: "Klasse", title: 'Klasse'),
            const SubstitutionFilterEditor(objKey: "Fach", title: 'Fach'),
            const SubstitutionFilterEditor(objKey: "Lehrer", title: 'Lehrer'),
            const SubstitutionFilterEditor(objKey: "Raum", title: 'Raum'),
            const SubstitutionFilterEditor(objKey: "Art", title: 'Art'),
            const SubstitutionFilterEditor(
                objKey: "Vertreter", title: "Vertreter"),
            const ListTile(
              leading: Icon(Icons.help),
              title: Text("Wie es Funktioniert?"),
              subtitle: Text(
                  "Wenn du einen Filter hinzufügst, werden nur noch Einträge angezeigt, die den Filter enthalten. Wenn du mehrere Filter hinzufügst, werden nur noch Einträge angezeigt, die alle/einen Filter enthalten."),
            )
          ],
        ));
  }
}

class SubstitutionFilterEditor extends StatefulWidget {
  final String objKey;
  final String title;

  const SubstitutionFilterEditor({required this.objKey, required this.title});

  @override
  _SubstitutionFilterEditorState createState() =>
      _SubstitutionFilterEditorState();
}

class _SubstitutionFilterEditorState extends State<SubstitutionFilterEditor> {
  bool strict = false;

  @override
  void initState() {
    super.initState();
    strict =
        client.substitutions.localFilter[widget.objKey]?["strict"] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child:
                      Text(widget.title, style: const TextStyle(fontSize: 18)),
                ),
                ActionChip(
                  label: strict ? const Text("All") : const Text("One"),
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  onPressed: () {
                    setState(() {
                      strict = !strict;
                      client.substitutions.localFilter[widget.objKey]
                          ?["strict"] = strict;
                      client.substitutions.saveFilterToStorage();
                    });
                  },
                )
              ],
            ),
            ChipsInput<String>(
              initialValue: client.substitutions.localFilter[widget.objKey]
                      ?["filter"] ??
                  [],
              enabled: true,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: "Edit Filter",
              ),
              findSuggestions: (String query) {
                if (query.trim().isEmpty) return [];
                return [query];
              },
              onChanged: (data) {
                client.substitutions.localFilter[widget.objKey] = {
                  "strict": strict
                };
                client.substitutions.localFilter[widget.objKey]?["filter"] =
                    data;
                client.substitutions.saveFilterToStorage();
              },
              chipBuilder: (context, state, profile) {
                return InputChip(
                  key: ObjectKey(profile),
                  label: Text(profile),
                  onDeleted: () => state.deleteChip(profile),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              },
              suggestionBuilder: (context, query) {
                return ListTile(
                  title: Text('"$query" hinzufügen'),
                );
              },
            )
          ],
        ));
  }
}
