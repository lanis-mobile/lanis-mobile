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

class _VertretungsplanAnsichtState extends State<VertretungsplanAnsicht>
    with TickerProviderStateMixin {
  final double padding = 12.0;

  List<GlobalKey<RefreshIndicatorState>>? globalKeys;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    client.substitutionsFetcher?.fetchData();
  }

  Widget noticeWidget() {
    return const ListTile(
      title: Text("Keine weiteren Einträge!", style: TextStyle(fontSize: 22)),
      subtitle: Text(
          "Alle Angaben ohne Gewähr. \nDie Funktionalität der App hängt stark von der verwendeten Schule und den eingestellten Filtern ab. Manche Einträge können auch merkwürdig aussehen, da deine Schule möglicherweise nicht alle Einträge vollständig eingegeben hat."),
    );
  }

  bool doesNoticeExist(String? info) {
    return (info == null || info == "" || info == "---");
  }

  Widget? getSubstitutionInfo(String key, String? value, IconData icon) {
    if (doesNoticeExist(value)) {
      return null;
    }

    return Padding(
        padding: const EdgeInsets.only(right: 30, left: 30, bottom: 2),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(icon),
              ),
              Text(
                key,
                style: Theme.of(context).textTheme.labelLarge,
              )
            ],
          ),
          Text(value!)
        ]));
  }

  Widget getSubstitutionWidget(Map<String, dynamic> substitution) {
    return ListTile(
      dense: (doesNoticeExist(substitution["Vertreter"]) &&
          doesNoticeExist(substitution["Lehrer"]) &&
          doesNoticeExist(substitution["Raum"]) &&
          doesNoticeExist(substitution["Fach"]) &&
          doesNoticeExist(substitution["Hinweis"])),
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
                    style: (substitution['Art'] != null)
                        ? null
                        : Theme.of(context)
                            .textTheme
                            .titleLarge) // highlight "Klasse" when there is no "Art" information
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
                padding: EdgeInsets.only(
                    top: 0,
                    bottom: (doesNoticeExist(substitution["Vertreter"]) &&
                            doesNoticeExist(substitution["Lehrer"]) &&
                            doesNoticeExist(substitution["Raum"]) &&
                            !doesNoticeExist(substitution["Fach"]))
                        ? 12
                        : 0),
                child: Column(
                  children: [
                    getSubstitutionInfo("Vertreter", substitution["Vertreter"],
                            Icons.person) ??
                        const SizedBox.shrink(),
                    getSubstitutionInfo(
                            "Lehrer", substitution["Lehrer"], Icons.school) ??
                        const SizedBox.shrink(),
                    getSubstitutionInfo(
                            "Raum", substitution["Raum"], Icons.room) ??
                        const SizedBox.shrink(),
                  ],
                ),
              ),
              if (!doesNoticeExist(substitution["Hinweis"])) ...[
                Padding(
                  padding: EdgeInsets.only(
                      right: 30,
                      left: 30,
                      top: 2,
                      bottom: doesNoticeExist(substitution["Fach"]) ? 12 : 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.info),
                          ),
                          Text(
                            "Hinweis",
                            style: Theme.of(context).textTheme.labelLarge,
                          )
                        ],
                      ),
                      Text(
                          "${toBeginningOfSentenceCase(substitution["Hinweis"])}")
                    ],
                  ),
                )
              ]
            ],
          ),
          if (!doesNoticeExist(substitution["Fach"])) ...[
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
        ],
      ),
    );
  }

  List<Widget> getSubstitutionViews(dynamic data) {
    List<Widget> substitutionViews = [];

    for (int dayIndex = 0; dayIndex < data["length"]; dayIndex++) {
      final int entriesLength = data["days"][dayIndex]["entries"].length;

      substitutionViews.add(RefreshIndicator(
        key: globalKeys![dayIndex + 1],
        onRefresh: () async {
          client.substitutionsFetcher?.fetchData(forceRefresh: true);
        },
        child: Padding(
          padding: EdgeInsets.only(left: padding, right: padding, top: padding),
          child: ListView.builder(
            itemCount: entriesLength + 1,
            itemBuilder: (context, entryIndex) {
              if (entryIndex == entriesLength) {
                return Padding(
                  padding: EdgeInsets.only(bottom: padding),
                  child: Card(
                    child: noticeWidget(),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: getSubstitutionWidget(
                      data["days"][dayIndex]["entries"][entryIndex]),
                ),
              );
            },
          ),
        ),
      ));
    }

    return substitutionViews;
  }

  List<Widget> getErrorWidgets(dynamic data) {
    List<Widget> errorWidgets = [];

    for (int i = 0; i < data["length"]; i++) {
      errorWidgets.add(ErrorView(data: data, name: "Vertretungsplan", fetcher: client.substitutionsFetcher,));
    }

    return errorWidgets;
  }

  List<Tab> getTabs(dynamic fullVplan) {
    List<Tab> tabs = [];

    for (Map day in fullVplan["days"]) {
      tabs.add(Tab(
        icon: const Icon(Icons.calendar_today),
        text: day["date"],
      ));
    }

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FetcherResponse>(
        stream: client.substitutionsFetcher?.stream,
        builder: (context, snapshot) {
          if (snapshot.data?.status == FetcherStatus.error &&
              snapshot.data?.content == -2) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountSettingsScreen()));
            });
          }

          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data?.status == FetcherStatus.fetching) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // GlobalKeys for RefreshIndicator and Refresh-FAB
          globalKeys = List.generate(snapshot.data?.content["length"] + 1, (index) => GlobalKey<RefreshIndicatorState>());

          // If there are no entries.
          if (snapshot.data?.content["length"] == 0) {
            return RefreshIndicator(
              key: globalKeys![0],
              onRefresh: () async {
                client.substitutionsFetcher?.fetchData(forceRefresh: true);
              },
              child: const CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.sentiment_dissatisfied,
                            size: 60
                        ),
                        Padding(
                          padding: EdgeInsets.all(35),
                          child: Text(
                              "Es gibt keine Vertretungen!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          // Vp could have multiple dates, so we need to set it dynamically.
          _tabController = TabController(
                length: snapshot.data?.content["length"], vsync: this);

          return Column(
            children: [
              TabBar(
                  controller: _tabController,
                  tabs: getTabs(snapshot.data?.content)),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    if (snapshot.data?.status == FetcherStatus.error) ...[
                      ...getErrorWidgets(snapshot.data?.content)
                    ] else ...[
                      ...getSubstitutionViews(snapshot.data?.content)
                    ]
                  ],
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => {
              for (GlobalKey<RefreshIndicatorState> globalKey in globalKeys!) {
                globalKey.currentState?.show()
              }
            },
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
