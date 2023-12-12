import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../client/client.dart';

class SendBugReportAnsicht extends StatefulWidget {
  const SendBugReportAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _SendBugReportAnsichtState();
}

class _SendBugReportAnsichtState extends State<SendBugReportAnsicht> {
  double padding = 10.0;

  TextEditingController bugDescriptionController = TextEditingController();
  TextEditingController contactInformationController = TextEditingController();
  bool sendMetadata = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bugreport senden"),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text("Danke, dass du aktiv zur Entwicklung der App beiträgst!"),
            subtitle: Text("Es ist schwierig, eine APP für alle Schulen zu entwickeln."),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: padding, right: padding, top: padding),
            child:
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 8,
              controller: bugDescriptionController,
              decoration: const InputDecoration(
                labelText: "Beschreibe den Bug",
                alignLabelWithHint: true,
                hintText: "Hier kannst du deinen Bug beschreiben...\n - Beschreibe den Bug... \n - Was hast du erwartet?\n - Was ist passiert?\n - Könnte es sich um ein Schulspezifisches Problem handeln?",
              ),
            ),
          ),
          Padding(
            padding:
            EdgeInsets.only(left: padding, right: padding, top: padding),
            child:
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              controller: contactInformationController,
              decoration: const InputDecoration(
                labelText: "Wie können wir dich erreichen?",
                alignLabelWithHint: true,
                hintText: "Vielleicht haben die Entwickler Fragen zu den Bugs. Eine Kontaktmöglichkeit wäre sehr hilfreich! \nz.B. Email oder Telefon",
              ),
            ),
          ),
          SwitchListTile(
            title: const Text("Metadaten Senden"),
            subtitle: const Text("Dies beinhaltet in der Regel sensible Informationen über deine Schule und deine Kurse. Eventuell auch Informationen über dich als Person. In den meisten Fällen ist diese Information notwendig, um den Fehler reproduzieren zu können. Dein Passwort wird nicht mit den Entwicklern geteilt."),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Wirklich senden?'),
                      content: const Text(
                        'Wenn du auf "OK" klickst, werden deine Informationen an die Entwickler gesendet. Diese Aktion kann nicht rückgängig gemacht werden.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                            showSendingDialog(context);

                            sendToServer(
                              bugDescriptionController.text,
                              contactInformationController.text,
                              sendMetadata,
                            ).then((result) {
                              Navigator.pop(context); // Dismiss loading dialog
                              // Handle result, e.g., show success message
                            }).catchError((error) {
                              Navigator.pop(context); // Dismiss loading dialog
                              print('Error sending bug report: $error');
                              // Handle error, e.g., show error message
                            });
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Bugreport senden."),
            ),
          ),
          const ListTile(
            trailing: Icon(Icons.info),
            title: Text("Wie gehen wir mit deinen Daten um?"),
            subtitle: Text("Sobald wir die Ursache des Fehlers gefunden haben oder den Fehler reproduzieren können, werden deine Daten umgehend gelöscht. Eventuell werden die Daten in einem gesicherten Rahmen mit anderen Entwicklern ausgetauscht."),
          ),
        ],
      ),
    );
  }
}

Future<dynamic> generateBugReport() async {
  debugPrint("Working on it...");
  //calendar date selection
  DateTime currentDate = DateTime.now();
  DateTime sixMonthsAgo = currentDate.subtract(const Duration(days: 180));
  DateTime oneYearLater = currentDate.add(const Duration(days: 365));
  final formatter = DateFormat('yyyy-MM-dd');

  //mein_unterricht
  final meinUnterricht = await client.getMeinUnterrichtOverview();
  List<dynamic> meinUnterrichtKurse = [];
  meinUnterricht["kursmappen"]?.forEach((kurs) async {
    meinUnterrichtKurse.add(
      (await client.getMeinUnterrichtCourseView(kurs["_courseURL"]))
    );
  });

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
    "data": {
      "vertretungsplan": await client.getFullVplan() ?? "Error",
      "kalender": await client.getCalendar(formatter.format(sixMonthsAgo), formatter.format(oneYearLater)) ?? "Error",
      "mein_unterricht": {
        "übersicht": meinUnterricht,
        "kurse": meinUnterrichtKurse
      },
      //TODO: add conversations
    }
  };
}

Future<int> sendToServer(String bugDescription, String contactInformation, bool sendMetaData) async {
  debugPrint("sending to server...");
  const apiEndpointLocation = "https://sph-bugreport-service.alessioc42.workers.dev/api/add";

  String deviceData = "none";
  if (sendMetaData) {
    try {
      deviceData = jsonEncode((await generateBugReport()) ?? '["Error loading data!"]');
    } catch (e) {
      deviceData = e.toString();
    }
  }

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
    return 0;
  } else {
    return -4;
  }
}

void showSendingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        title: Text('Sende Bugreport...'),
        content: Center(
          heightFactor: 1,
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}