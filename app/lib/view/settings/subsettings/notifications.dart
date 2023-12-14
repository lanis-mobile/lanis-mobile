import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:permission_handler/permission_handler.dart';


class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _enableNotifications = true;
  int _notificationInterval = 15;
  bool _notificationsAreOngoing = false;
  bool _notificationPermissionGranted = false;

  Future<void> applySettings() async {
    await globalStorage.write(key: "settings-push-service-on", value: _enableNotifications.toString());
    await globalStorage.write(key: "settings-push-service-interval", value: _notificationInterval.toString());
    await globalStorage.write(key: "settings-push-service-notifications-ongoing", value: _notificationsAreOngoing.toString());
  }

  Future<void> loadSettingsVariables() async {
    _enableNotifications = (await globalStorage.read(key: "settings-push-service-on") ?? "true") == "true";
    _notificationInterval = int.parse(await globalStorage.read(key: "settings-push-service-interval") ?? "15");
    _notificationsAreOngoing = (await globalStorage.read(key: "settings-push-service-notifications-ongoing") ?? "false") == "true";

    _notificationPermissionGranted = await Permission.notification.isGranted;
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
        _notificationsAreOngoing = _notificationsAreOngoing;
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
          SwitchListTile(
            title: const Text('Anhaltende Benachrichtigung'),
            value: _notificationsAreOngoing,
            onChanged: _enableNotifications ? (bool? value) {
              setState(() {
                _notificationsAreOngoing = value!;
              });
            } : null,
          ),
          ListTile(
            title: const Text('Update-intervall'),
            trailing: Text('$_notificationInterval min', style: const TextStyle(fontSize: 14)),
          ),
          Slider(
            value: _notificationInterval.toDouble(),
            min: 15,
            max: 180,
            onChanged: _enableNotifications ? (double value) {
              setState(() {
                _notificationInterval = value.toInt(); // Umwandlung zu int
              });
            } : null,
          ),
          SwitchListTile(
            title: const Text('Systemberechtigung für Benachrichtigungen'),
            value: _notificationPermissionGranted,
            onChanged: (bool? value) async {
              if (!_notificationPermissionGranted) {
                PermissionStatus status = await Permission.notification.request();
                setState(() {
                  _notificationPermissionGranted =  status.isGranted;
                });
              }
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

                String message = "Ein Neustart der Anwendung ist erforderlich, um Änderungen zu übernehmen.";

                if (!_notificationPermissionGranted) {
                  message = "Es gibt ein Problem mit der Berechtigung für Benachrichtigungen! SPH kann keine Benachrichtigungen versenden.";
                }

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("App Neustart erforderlich"),
                      content: Text(message),
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
