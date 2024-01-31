import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Benachrichtigungen"),
      ),
      body: ListView(
        children: [
          if (Platform.isIOS) const ListTile(
            leading: Icon(Icons.info),
            title: Text("Leider keiner Unterstützung"),
            subtitle: Text("Auf deinem Endgerät (IOS / IpadOS) werden keine Benachrichtigungen unterstützt."),
            ),
          const NotificationElements(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text("Information"),
            subtitle: Text(
                "Die Häufigkeit und der Zeitpunkt der Aktualisierung des Vertretungsplans hängen von verschiedenen Faktoren des Endgeräts ab. Im Akkusparmodus wird der Vertretungsplan beispielsweise oft nicht aktualisiert."),
          ),
        ],
      ),
    );
  }
}

class NotificationElements extends StatefulWidget {
  const NotificationElements({super.key});

  @override
  State<NotificationElements> createState() => _NotificationElementsState();
}

class _NotificationElementsState extends State<NotificationElements> {
  bool _enableNotifications = true;
  int _notificationInterval = 15;
  bool _notificationsAreOngoing = false;
  bool _notificationPermissionGranted = false;

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

        _notificationPermissionGranted = _notificationPermissionGranted;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Systemberechtigung für Benachrichtigungen'),
          trailing: Text(_notificationPermissionGranted ? "Erlaubt" : "Nicht erlaubt"),
          subtitle: !_notificationPermissionGranted ? const Text("Du musst deine Berechtigungen für Benachrichtigungen in den Systemeinstellungen der App ändern!") : null,
        ),
        SwitchListTile(
          title: const Text('Push-Benachrichtigungen'),
          value: _enableNotifications,
          onChanged: _notificationPermissionGranted ? (bool? value) async {
            setState(() {
              _enableNotifications = value!;
            });
            await globalStorage.write(key: "settings-push-service-on", value: _enableNotifications.toString());
          } : null,
          subtitle: const Text("Aktiviere es, um Benachrichtigungen zu bekommen."),
        ),
        SwitchListTile(
          title: const Text('Anhaltende Benachrichtigung'),
          value: _notificationsAreOngoing,
          onChanged: _enableNotifications && _notificationPermissionGranted ? (bool? value) async {
            setState(() {
              _notificationsAreOngoing = value!;
            });
            await globalStorage.write(key: "settings-push-service-notifications-ongoing", value: _notificationsAreOngoing.toString());
          } : null,
          subtitle: const Text("Wenn aktiviert, werden die Benachrichtigung dauerhaft fest stehen, die man nicht entfernen kann."),
        ),
        ListTile(
          title: const Text('Update-Intervall'),
          trailing: Text('$_notificationInterval min', style: const TextStyle(fontSize: 14)),
          enabled: _enableNotifications && _notificationPermissionGranted,
        ),
        Slider(
          value: _notificationInterval.toDouble(),
          min: 15,
          max: 180,
          onChanged: _enableNotifications && _notificationPermissionGranted ? (double value) {
            setState(() {
              _notificationInterval = value.toInt(); // Umwandlung zu int
            });
          } : null,
          onChangeEnd: (double value) async {
            await globalStorage.write(key: "settings-push-service-interval", value: _notificationInterval.toString());
          },
        ),
      ],
    );
  }
}
