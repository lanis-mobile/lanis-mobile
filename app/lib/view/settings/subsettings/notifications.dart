import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _enableNotifications = true;
  int _notificationInterval = 15;

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
            subtitle: Text("Die Häufigkeit und der Zeitpunkt der Aktualisierung des Vertretungsplans hängen von verschiedenen Faktoren des Endgeräts ab. Im Akkusparmodus wird der Vertretungsplan beispielsweise oft nicht aktualisiert.\nEin Neustart der Anwendung ist erforderlich, um Änderungen zu übernehmen."),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
                onPressed: (){},
                child: const Text("änderungen Speichern"),

            ),
          )
        ],
      ),
    );
  }
}
