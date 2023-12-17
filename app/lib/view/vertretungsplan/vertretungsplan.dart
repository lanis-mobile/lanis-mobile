import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sph_plan/client/fetcher.dart';

import '../../client/client.dart';
import '../bug_report/send_bugreport.dart';
import '../settings/subsettings/user_login.dart';
import 'filterlogic.dart';
import 'filtersettings.dart';

class VertretungsplanAnsicht extends StatefulWidget {
  const VertretungsplanAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _VertretungsplanAnsichtState();
}

class _VertretungsplanAnsichtState extends State<VertretungsplanAnsicht> {
  final double padding = 12.0;
  final GlobalKey<RefreshIndicatorState> _vpRefreshIndicatorKey0 =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    client.substitutionsFetcher.fetchData();
  }

  Widget noticeWidget() {
    return const ListTile(
      title: Text(
          "Keine weiteren Einträge!",
          style: TextStyle(fontSize: 22)
      ),
      subtitle: Text("Alle Angaben ohne Gewähr. \nDie Funktionalität der App hängt stark von der verwendeten Schule und den eingestellten Filtern ab. Manche Einträge können auch merkwürdig aussehen, da deine Schule möglicherweise nicht alle Einträge vollständig eingegeben hat."),
    );
  }

  Widget? getSubstitutionInfo(String key, String? value) {
    if (value == null || value == "" || value == "---") {
      return null;
    }

    return Padding(
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("$key:"), Text(value)],
        ));
  }

  Widget getSubstitutionWidget(Map<String, dynamic> substitution) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (substitution['Art'] != null) ...[
            Text(
              substitution['Art'],
              style: const TextStyle(fontSize: 22),
            )
          ],
          Flexible(
              child: Text(substitution["Klasse"] ?? "Klasse nicht angegeben",
                  style: TextStyle(
                      fontSize: (substitution['Art'] != null)
                          ? null
                          : 22) // highlight "Klasse" when there is no "Art" information
                  )),
          Text(
            substitution['Stunde'] ?? "",
            style: const TextStyle(fontSize: 22),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 0,
            children: [
              getSubstitutionInfo("Vertreter", substitution["Vertreter"]) ??
                  const SizedBox.shrink(),
              getSubstitutionInfo("Lehrer", substitution["Lehrer"]) ??
                  const SizedBox.shrink(),
              getSubstitutionInfo("Raum", substitution["Raum"]) ??
                  const SizedBox.shrink(),
              if (substitution["Hinweis"] != null &&
                  substitution["Hinweis"] != "") ...[
                Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: Text("Hinweis: ${substitution["Hinweis"]}"),
                )
              ]
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDateString(substitution["Tag_en"], substitution["Tag"]),
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                substitution["Fach"] ?? "",
                style: const TextStyle(fontSize: 18),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FetcherResponse>(
          stream: client.substitutionsFetcher.stream,
          builder: (context, snapshot) {
            if (snapshot.data?.status == FetcherStatus.error && snapshot.data?.content == -2) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountSettingsScreen()));
              });
            }

            return RefreshIndicator(
                key: _vpRefreshIndicatorKey0,
                onRefresh: () async {
                  client.substitutionsFetcher.fetchData(forceRefresh: true);
                },
                child: snapshot.data?.status == FetcherStatus.error
                    // Error content, we use CustomScrollView to allow "scroll for refresh"
                    ? CustomScrollView(
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
                                  "Problem: ${client.statusCodes[snapshot.data?.content] ?? "Unbekannter Fehler"}"
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
                                                        "AUTOMATISCH GENERIERT:\nEin Fehler ist beim Vertretungsplan aufgetreten:\n${snapshot.data?.content}: ${client.statusCodes[snapshot.data?.content]}\n\nMehr Details von dir:\n")),
                                          );
                                        },
                                        child: const Text(
                                            "Fehlerbericht senden")),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: OutlinedButton(
                                          onPressed: () async {
                                            client.substitutionsFetcher.fetchData(forceRefresh: true);
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
                    )
                    : snapshot.data?.status == FetcherStatus.fetching || snapshot.data == null
                        // Waiting content
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        // Successful content
                        : Padding(
                          padding: EdgeInsets.only(left: padding, right: padding),
                          child: ListView.builder(
                              itemCount: snapshot.data?.content.length + 1,
                              itemBuilder: (context, index) {
                                if (index == snapshot.data?.content.length) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: padding),
                                    child: Card(
                                      child: noticeWidget(),
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: EdgeInsets.only(bottom: padding),
                                  child: Card(
                                    child: getSubstitutionWidget(
                                        snapshot.data?.content[index]),
                                  ),
                                );
                              },
                            ),
                        ));
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _vpRefreshIndicatorKey0.currentState?.show(),
            heroTag: "RefreshSubstitutions",
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "FilterSubstitutions",
            onPressed: () {
              client.substitutionsFetcher.fetchData();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => FilterPlan()))
                  .then((_) => setState(() {
                        client.substitutionsFetcher
                            .fetchData(forceRefresh: true);
                      }));
            },
            child: const Icon(Icons.filter_alt),
          ),
        ],
      ),
    );
  }
}