import 'package:flutter/material.dart';

import '../../client/fetcher.dart';
import '../../view/bug_report/send_bugreport.dart';
import '../exceptions/client_status_exceptions.dart';

class ErrorView extends StatelessWidget {
  late final LanisException data;
  late final Fetcher? fetcher;
  late final String name;
  ErrorView(
      {super.key,
      required this.data,
      required this.name,
      required this.fetcher});
  ErrorView.fromCode(
      {super.key,
      required int data,
      required this.name,
      required this.fetcher}) {
    this.data = LanisException.fromCode(data);
  }

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
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              Text("Problem: ${data.cause}"),
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                        onPressed: () {
                          if (data is NoConnectionException) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Hinweis"),
                                    content: const Text(
                                        "Sende nur einen Fehlerbericht, wenn du dir zu 100% sicher bist, dass es nicht vom fehlenden Internet ausgelöst wird."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Zurück")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BugReportScreen(
                                                          generatedMessage:
                                                              "AUTOMATISCH GENERIERT:\nEin Fehler ist bei(m) $name aufgetreten:\n${data.cause}\n\nMehr Details von dir:\n")),
                                            );
                                          },
                                          child:
                                              const Text("Ich bin mir sicher")),
                                    ],
                                  );
                                });
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BugReportScreen(
                                    generatedMessage:
                                        "AUTOMATISCH GENERIERT:\nEin Fehler ist bei(m) $name aufgetreten:\n${data.cause}\n\nMehr Details von dir:\n")),
                          );
                        },
                        child: const Text("Fehlerbericht senden")),
                    if (fetcher != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: OutlinedButton(
                            onPressed: () async {
                              fetcher!.fetchData(forceRefresh: true);
                            },
                            child: const Text("Erneut versuchen")),
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
