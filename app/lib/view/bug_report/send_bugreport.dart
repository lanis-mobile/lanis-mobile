import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';

import '../../client/client.dart';
import '../../shared/apps.dart';

class BugReportScreen extends StatefulWidget {
  final String? generatedMessage;
  const BugReportScreen({super.key, this.generatedMessage});

  @override
  State<StatefulWidget> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  double padding = 10.0;

  TextEditingController bugDescriptionController = TextEditingController();
  TextEditingController contactInformationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool sendMetadata = true;

  @override
  void initState() {
    bugDescriptionController.text = widget.generatedMessage ?? "";
    super.initState();
  }

  void clearInputs() {
    setState(() {
      bugDescriptionController.text = "";
      contactInformationController.text = "";
      sendMetadata = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fehlerbericht senden"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const ListTile(
              title: Text("Danke, dass du aktiv zur Entwicklung der App beiträgst!"),
              subtitle: Text("Es ist schwierig, eine APP für alle Schulen zu entwickeln."),
            ),
            Padding(
              padding:
              EdgeInsets.only(left: padding, right: padding, top: padding),
              child:
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                controller: bugDescriptionController,
                decoration: const InputDecoration(
                  labelText: "Beschreibe den Bug",
                  alignLabelWithHint: true,
                  hintText: "Hier kannst du deinen Bug beschreiben...\n - Sei so genau wie möglich \n - Was hast du erwartet?\n - Was ist passiert?\n - Könnte es sich um ein Schulspezifisches Problem handeln?",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bitte beschreibe den Bug.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
              EdgeInsets.only(left: padding, right: padding, top: padding),
              child:
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                controller: contactInformationController,
                decoration: const InputDecoration(
                  labelText: "Wie können wir dich erreichen?",
                  alignLabelWithHint: true,
                  hintText: "Vielleicht haben die Entwickler Fragen zu den Bugs. Eine Kontaktmöglichkeit wäre sehr hilfreich! \nz.B. Email oder Telefon",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bitte gib Kontaktinformationen an.';
                  }
                  return null;
                },
              ),
            ),
            SwitchListTile(
                title: const Text("Metadaten Senden"),
                subtitle: const Text("Dies beinhaltet in der Regel sensible Informationen über deine Schule und deine Kurse. Eventuell auch Informationen über dich als Person. In den meisten Fällen sind diese Informationen notwendig, um den Fehler reproduzieren zu können. Dein Passwort wird nicht mit den Entwicklern geteilt."),
                value: sendMetadata,
                onChanged: (state) {
                  setState(() {
                    sendMetadata = state;
                  });
                }
            ),
            Padding(
              padding: EdgeInsets.only(left: padding, right: padding, top: padding),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context_) {
                        return AlertDialog(
                          title: const Text('Wirklich senden?'),
                          content: const Text(
                            'Wenn du auf "OK" klickst, werden deine Informationen an die Entwickler gesendet. Diese Aktion kann nicht rückgängig gemacht werden.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context_, 'Cancel');
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context_, 'OK');
                                showSendingDialog(context);

                                sendToServer(
                                  bugDescriptionController.text,
                                  contactInformationController.text,
                                  sendMetadata,
                                ).then((void _) {
                                  Navigator.pop(context);
                                  showDialog(context: context, builder: (context) => AlertDialog(
                                    title: const Text("Erfolg!"),
                                    content: const Text("Der Fehlerbericht wurde Gesendet."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, "OK"),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ));
                                  clearInputs();
                                }).catchError((ex) {
                                  if (ex is LanisException) {
                                    debugPrint("Fehlerbericht nicht gesendet: ${ex.cause}");
                                    showDialog(context: context, builder: (context) => AlertDialog(
                                      title: const Text("Fehler!"),
                                      content: const Text("Der Fehlerbericht wurde nicht Gesendet."),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, "OK"),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ));
                                  } else {
                                    Navigator.pop(context);
                                    debugPrint('Error sending bug report: $ex');
                                  }
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text("Fehlerbericht senden."),
              ),
            ),
            const ListTile(
              trailing: Icon(Icons.info),
              title: Text("Wie gehen wir mit deinen Daten um?"),
              subtitle: Text("Sobald wir die Ursache des Fehlers gefunden haben oder den Fehler reproduzieren können, werden deine Daten umgehend gelöscht. Eventuell werden die Daten in einem gesicherten Rahmen mit anderen Entwicklern ausgetauscht."),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> generateBugReport() async {
  //calendar date selection
  DateTime currentDate = DateTime.now();
  DateTime sixMonthsAgo = currentDate.subtract(const Duration(days: 180));
  DateTime oneYearLater = currentDate.add(const Duration(days: 365));
  final formatter = DateFormat('yyyy-MM-dd');


  //mein_unterricht
  late dynamic meinUnterricht;
  late List<dynamic> meinUnterrichtKurse = [];
  if (client.doesSupportFeature(SPHAppEnum.meinUnterricht)) {
    meinUnterricht = await client.meinUnterricht.getOverview();
    meinUnterricht["kursmappen"]?.forEach((kurs) async {
      meinUnterrichtKurse.add(
          (await client.meinUnterricht.getCourseView(kurs["_courseURL"]))
      );
    });
  } else {
    meinUnterrichtKurse = ["No support."];
  }

  //nachrichten beta-version
  late dynamic visibleMessages;
  late dynamic invisibleMessages;
  late dynamic firstSingleMessage;
  if (client.doesSupportFeature(SPHAppEnum.nachrichten)) {
    visibleMessages = await client.conversations.getOverview(false);

    for (var element in visibleMessages) {
      element.remove("empf");
    }

    invisibleMessages = await client.conversations.getOverview(true);

    for (var element in invisibleMessages) {
      element.remove("empf");
    }
    try {
      firstSingleMessage = await client.conversations.getSingleConversation(visibleMessages[0]["Uniquid"]); // Single Conversations have more possible dict keys.
    } on LanisException catch (ex) {
      firstSingleMessage = "LanisException: ${ex.cause}";
    }
  }

  return {
    "app": (await PackageInfo.fromPlatform()).data,
    "school": {
      "id": client.schoolID,
      "name": client.schoolName,
      "apps": client.supportedApps
    },
    "user": {
      "username": client.username,
      "userdata": await client.fetchUserData()
    },
    "applets": {
      "vertretungsplan": client.doesSupportFeature(SPHAppEnum.vertretungsplan) ? await client.substitutions.getAllSubstitutions() ?? [] : [],
      "kalender": client.doesSupportFeature(SPHAppEnum.kalender) ? await client.calendar.getCalendar(formatter.format(sixMonthsAgo), formatter.format(oneYearLater)) ?? [] : [],
      "mein_unterricht": {
        "übersicht": meinUnterricht,
        "kurse": meinUnterrichtKurse
      },
      "nachrichten": (client.doesSupportFeature(SPHAppEnum.nachrichten)) ? {
        "eingeblendete": visibleMessages,
        "ausgeblendete": invisibleMessages,
        "erste_detaillierte_nachricht": firstSingleMessage
      } : []
    }
  };
}

Future<void> sendToServer(String bugDescription, String contactInformation, bool sendMetaData) async {
  const apiEndpointLocation = "https://sph-bugreport-service.alessioc42.workers.dev/api/add";

  late dynamic deviceData = {"applets":[]};
  if (sendMetaData) {
    try {
      deviceData = ((await generateBugReport()) ?? '["Error loading data!"]');
    } catch (e) {
      deviceData = e.toString();
    }
  }

  try {
    final response = await client.dio.post(
      apiEndpointLocation,
      data: {
        "username": "${client.schoolID}.${client.username}",
        "report": bugDescription,
        "contact_information": contactInformation,
        "device_data": deviceData,
      },
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw LoggedOffOrUnknownException();
    }
  } on (SocketException,) {
    throw NetworkException();
  } catch (e) {
    debugPrint(e.toString());
    throw LoggedOffOrUnknownException();
  }
}

void showSendingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        title: Text('Sende Fehlerbericht...'),
        content: Center(
          heightFactor: 1,
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}