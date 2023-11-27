import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _enableNotifications = true;
  int _notificationInterval = 15;

  Future<void> applySettings() async {
    await globalStorage.write(key: "settings-push-service-on", value: _enableNotifications.toString());
    await globalStorage.write(key: "settings-push-service-interval", value: _notificationInterval.toString());
  }

  Future<void> loadSettingsVariables() async {
    _enableNotifications = (await globalStorage.read(key: "settings-push-service-on") ?? "true") == "true";
    _notificationInterval = int.parse(await globalStorage.read(key: "settings-push-service-interval") ?? "15");
  }

  @override
  void initState() {
    super.initState();
    // Use await to ensure that loadSettingsVariables completes before continuing
    loadSettingsVariables().then((_) {
      setState(() {
        // Set the state after loading the variables
        _enableNotifications = _enableNotifications;
        _notificationInterval = _notificationInterval;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Benachrichtigungen"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push Benachrichtigungen'),
            value: _enableNotifications,
            onChanged: (bool? value) {
              setState(() {
                _enableNotifications = value!;
              });
            },
          ),
          ListTile(
            title: const Text('Update-intervall'),
            trailing: Text('$_notificationInterval min', style: const TextStyle(fontSize: 14)),
          ),
          Slider(
            value: _notificationInterval.toDouble(),
            min: 15,
            max: 180,
            onChanged: (double value) {
              setState(() {
                _notificationInterval = value.toInt(); // Umwandlung zu int
              });
            },
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text("Information"),
            subtitle: Text(
                "Die Häufigkeit und der Zeitpunkt der Aktualisierung des Vertretungsplans hängen von verschiedenen Faktoren des Endgeräts ab. Im Akkusparmodus wird der Vertretungsplan beispielsweise oft nicht aktualisiert."),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              onPressed: () {
                applySettings();

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text("App Neustart erforderlich"),
                        content: Text("Ein Neustart der Anwendung ist erforderlich, um Änderungen zu übernehmen."),
                      );
                    }
                );
              },
              child: const Text("Änderungen Speichern"),
            ),
          )
        ],
      ),
    );
  }
}
