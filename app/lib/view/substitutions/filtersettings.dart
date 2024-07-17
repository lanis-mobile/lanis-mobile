import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';

import '../../client/client.dart';
import '../../client/client_submodules/substitutions.dart';


class FilterSettingsScreen extends StatefulWidget {
  const FilterSettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FilterSettingsScreenState();
}

class _FilterSettingsScreenState extends State<FilterSettingsScreen> {
  String apiURL = "https://lanis-mobile-api.alessioc42.workers.dev";
  bool loadingFilter = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.substitutionsFilter),
          actions: [
            IconButton(
              icon: const Icon(Icons.developer_mode),
              tooltip: AppLocalizations.of(context)!.developmentMode,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.developmentMode),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(AppLocalizations.of(context)!.developmentModeHint),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                apiURL = value;
                              });
                            },
                            controller: TextEditingController(text: apiURL),
                            decoration: const InputDecoration(hintText: "edit API url"),
                          )
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
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
                    child: Text(AppLocalizations.of(context)!.reset)),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        if (loadingFilter) return;
                        loadingFilter = true;
                        final dio = Dio();
                        final response = await dio.post(
                            "$apiURL/api/filter/generate",
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
                          if (!(data["result"] == null)) {
                            final filterResponse = data["result"]["task"];
                            client.substitutions.localFilter = Map<String, EntryFilter>.from(filterResponse).map((key, value) {
                              return MapEntry(key, parseEntryFilter(Map<String, dynamic>.from(value)));
                            });
                            client.substitutions.saveFilterToStorage();
                          } else {
                            //message with scaffoldmessenger to indicate that there is no data
                            client.substitutions.localFilter = {};
                            client.substitutions.saveFilterToStorage();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.autoSetToEmpty)));
                          }
                          Navigator.pop(context);
                        } else {
                          //caught to open modal
                          throw ErrorDescription("API request had no success");
                        }
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!.error),
                              content: Text(AppLocalizations.of(context)!.errorInAutoSet),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                        );
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.autoSet)),
              ],
            ),
            const SubstitutionFilterEditor(objKey: "Klasse", title: 'Klasse'),
            const SubstitutionFilterEditor(objKey: "Fach", title: 'Fach'),
            const SubstitutionFilterEditor(objKey: "Lehrer", title: 'Lehrer'),
            const SubstitutionFilterEditor(objKey: "Raum", title: 'Raum'),
            const SubstitutionFilterEditor(objKey: "Art", title: 'Art'),
            const SubstitutionFilterEditor(objKey: "Vertreter", title: "Vertreter"),
            const SubstitutionFilterEditor(objKey: "Lehrerkuerzel", title: "Lehrerkürzel"),
            const SubstitutionFilterEditor(objKey: "Vertreterkuerzel", title: "Vertreterkürzel"),
            const SubstitutionFilterEditor(objKey: "Hinweis", title: "Hinweis"),
            const SubstitutionFilterEditor(objKey: "Fach_alt", title: "Fach (Alt)"),
            const SubstitutionFilterEditor(objKey: "Raum_alt", title: "Raum (Alt)"),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text(AppLocalizations.of(context)!.howItWorks),
              subtitle: Text(AppLocalizations.of(context)!.howItWorksText)
            )
          ],
        ));
    }
}

class SubstitutionFilterEditor extends StatefulWidget {
  final String objKey;
  final String title;

  const SubstitutionFilterEditor({super.key, required this.objKey, required this.title});

  @override
  _SubstitutionFilterEditorState createState() =>
      _SubstitutionFilterEditorState();
}

class _SubstitutionFilterEditorState extends State<SubstitutionFilterEditor> {
  bool strict = false;
  late List<Tag> filterTags;

  @override
  void initState() {
    super.initState();
    strict =
        client.substitutions.localFilter[widget.objKey]?["strict"] ?? false;
    List<String> filterStrings = (client.substitutions.localFilter[widget.objKey]?["filter"]??[]);
    filterTags = filterStrings.map((e) => Tag(e)).toList();
  }

  @override
  void dispose() {
    filterTags.clear();
    super.dispose();
  }

  void overrideFilter(List<String> data) {
    client.substitutions.localFilter[widget.objKey] = {
      "strict": strict
    };
    client.substitutions.localFilter[widget.objKey]?["filter"] =
        data;
    client.substitutions.saveFilterToStorage();
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
            FlutterTagging<Tag>(
              initialItems: filterTags,
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.addFilter,
                  labelText: AppLocalizations.of(context)!.addFilter,
                ),
              ),
              configureChip: (tag) {
                return ChipConfiguration(
                  label: Text(tag.name),
                );
              },
              configureSuggestion: (tag) {
                return SuggestionConfiguration(
                  title: Text(AppLocalizations.of(context)!.addSpecificFilter(tag.name))
                );
              },
              findSuggestions: (String query) {
                query = query.trim();
                if (query.isEmpty) return <Tag>[];
                return <Tag>[Tag(query)];
              },
              onChanged: () {
                overrideFilter(filterTags.map((e) => e.name).toList());
              },
            )
          ],
        ));
  }
}

class Tag extends Taggable {
  final String name;

  const Tag(this.name);

  @override
  List<Object> get props => [name];
}