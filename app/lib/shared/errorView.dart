import 'package:flutter/material.dart';

import '../client/client.dart';
import '../client/fetcher.dart';
import '../view/bug_report/send_bugreport.dart';

class ErrorView extends StatelessWidget {
  late final int data;
  late final Fetcher? fetcher;
  ErrorView({super.key, required this.data, required this.fetcher});

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
                    "Es gab wohl ein Problem, bitte sende einen Fehlerbericht!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                    if (fetcher != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: OutlinedButton(
                            onPressed: () async {
                              fetcher!.fetchData(forceRefresh: true);
                            },
                            child:
                            const Text("Erneut versuchen")),
                      )
                    ]
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
