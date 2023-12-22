import 'package:flutter/material.dart';

import '../client/client.dart';
import '../view/bug_report/send_bugreport.dart';

class ErrorView extends StatelessWidget {
  final int data;
  const ErrorView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning,
                size: 60,
              ),
              const Padding(
                padding: EdgeInsets.all(35),
                child: Text(
                    "Es gibt wohl ein Problem, bitte sende einen Fehlerbericht!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
              ),
              Text(
                  "Problem: ${client.statusCodes[data] ?? "Unbekannter Fehler"}"
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BugReportScreen(
                                        generatedMessage:
                                        "AUTOMATISCH GENERIERT:\nEin Fehler ist beim Vertretungsplan aufgetreten:\n$data: ${client.statusCodes[data]}\n\nMehr Details von dir:\n")),
                          );
                        },
                        child: const Text(
                            "Fehlerbericht senden")),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: OutlinedButton(
                          onPressed: () async {
                            client.substitutionsFetcher?.fetchData(forceRefresh: true);
                          },
                          child:
                          const Text("Erneut versuchen")),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
