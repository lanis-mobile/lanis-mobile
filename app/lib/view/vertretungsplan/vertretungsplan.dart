import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/client/fetcher.dart';

import '../../client/client.dart';
import '../../shared/errorView.dart';
import '../settings/subsettings/user_login.dart';
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
    client.substitutionsFetcher?.fetchData();
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

  bool doesInfoExist(String? info) {
    var sdfsdf = (info == null || info == "" || info == "---");
    print(sdfsdf);
    //print(info);
    return sdfsdf;
  }

  Widget? getSubstitutionInfo(String key, String? value, IconData icon) {
    if (doesInfoExist(value)) {
      return null;
    }

    return Padding(
        padding: const EdgeInsets.only(right: 30, left: 30, bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(icon),
                ),
                Text(key, style: Theme.of(context).textTheme.labelLarge,)
              ],
            ),
            Text(value!)]
        ));
  }

  Widget getSubstitutionWidget(Map<String, dynamic> substitution) {
    return ListTile(
      dense: (doesInfoExist(substitution["Vertreter"]) && doesInfoExist(substitution["Lehrer"]) && doesInfoExist(substitution["Raum"]) && doesInfoExist(substitution["Fach"]) && doesInfoExist(substitution["Hinweis"])),
      title: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (substitution['Art'] != null) ...[
              Text(
                substitution['Art'],
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
            Flexible(
                child: Text(substitution["Klasse"] ?? "Keine Klasse angegeben",
                    style: (substitution['Art'] != null) ? null : Theme.of(context).textTheme.titleLarge) // highlight "Klasse" when there is no "Art" information
            ),
            Text(
              substitution['Stunde'] ?? "",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: (doesInfoExist(substitution["Vertreter"]) && doesInfoExist(substitution["Lehrer"]) && doesInfoExist(substitution["Raum"]) && !doesInfoExist(substitution["Fach"])) ? 12 : 0),
                child: Column(
                  children: [
                    getSubstitutionInfo("Vertreter", substitution["Vertreter"], Icons.person) ??
                        const SizedBox.shrink(),
                    getSubstitutionInfo("Lehrer", substitution["Lehrer"], Icons.school) ??
                        const SizedBox.shrink(),
                    getSubstitutionInfo("Raum", substitution["Raum"], Icons.room) ??
                        const SizedBox.shrink(),
                  ],
                ),
              ),
              if (!doesInfoExist(substitution["Hinweis"])) ...[
                Padding(
                  padding: EdgeInsets.only(right: 30, left: 30, top: 2, bottom: doesInfoExist(substitution["Fach"]) ? 12 : 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.info),
                          ),
                          Text("Hinweis", style: Theme.of(context).textTheme.labelLarge,)
                        ],
                      ),
                      Text("${toBeginningOfSentenceCase(substitution["Hinweis"])}")
                    ],
                  ),
                )
              ]
            ],
          ),
          if (!doesInfoExist(substitution["Fach"])) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  substitution["Fach"],
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            )
          ]
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDateString(substitution["Tag_en"], substitution["Tag"]),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FetcherResponse>(
          stream: client.substitutionsFetcher?.stream,
          builder: (context, snapshot) {
            if (snapshot.data?.status == FetcherStatus.error && snapshot.data?.content == -2) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountSettingsScreen()));
              });
            }

            return RefreshIndicator(
                key: _vpRefreshIndicatorKey0,
                onRefresh: () async {
                  client.substitutionsFetcher?.fetchData(forceRefresh: true);
                },
                child: snapshot.data?.status == FetcherStatus.error
                    // Error content, we use CustomScrollView to allow "scroll for refresh"
                    ? ErrorView(data: snapshot.data?.content)
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
                                  padding: EdgeInsets.only(bottom: 8),
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
              client.substitutionsFetcher?.fetchData();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => FilterPlan()))
                  .then((_) => setState(() {
                        client.substitutionsFetcher
                            ?.fetchData(forceRefresh: true);
                      }));
            },
            child: const Icon(Icons.filter_alt),
          ),
        ],
      ),
    );
  }
}