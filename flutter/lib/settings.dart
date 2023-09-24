import 'package:flutter/material.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    double padding = 8.0;
    const subHeaderStyle = TextStyle(
      fontSize: 24,
    );

    return Scaffold(
      body: Column(
        children: [
          const Text("Account", style: subHeaderStyle),
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Schulnummer (eg 5182)'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Benutzername (user.name)'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Login'),
            ),
          ),
          const Text("Vertretungsplan Filter", style: subHeaderStyle),
          Padding(
            padding: EdgeInsets.all(padding),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Klassenstufe'),
              items: generateKlassenStufeDropDownItems(),
              onChanged: (value) {
                // Handle the selected value.
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Klasse'),
              items: generateKlassenDropDownItems(),
              onChanged: (value) {
                // Handle the selected value.
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Lehrer Kürzel'),
            ),
          ),
        ],
      ),
    );
  }
}

List<DropdownMenuItem<String>> generateKlassenStufeDropDownItems() {
  List<DropdownMenuItem<String>> items = [];

  List<String> otherOptions = ["Alle","Q", "E"];
  for (int i = 0; i <= otherOptions.length-1; i++) {
    items.add(
      DropdownMenuItem<String>(
        value: otherOptions[i],
        child: Text(otherOptions[i]),
      ),
    );
  }

  for (int i = 1; i <= 10; i++) {
    items.add(
      DropdownMenuItem<String>(
        value: i.toString(),
        child: Text(i.toString()),
      ),
    );
  }

  return items;
}

List<DropdownMenuItem<String>> generateKlassenDropDownItems() {
  List<DropdownMenuItem<String>> items = [];

  List<String> otherOptions = ["Alle", "a", "b","c", "d", "e", "f", "g", "h", "i", "j", "k", "1/2", "3/4"];
  for (int i = 0; i <= otherOptions.length-1; i++) {
    items.add(
      DropdownMenuItem<String>(
        value: otherOptions[i],
        child: Text(otherOptions[i]),
      ),
    );
  }

  return items;
}
