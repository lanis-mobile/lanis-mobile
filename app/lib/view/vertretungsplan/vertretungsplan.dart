import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:sph_plan/shared/apps.dart';
import 'package:sph_plan/view/vertretungsplan/substitutionWidget.dart';

import '../../client/client.dart';
import '../../shared/errorView.dart';
import '../login/screen.dart';
import 'filtersettings.dart';

class VertretungsplanAnsicht extends StatefulWidget {
  const VertretungsplanAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _VertretungsplanAnsichtState();
}

class _VertretungsplanAnsichtState extends State<VertretungsplanAnsicht>
    with TickerProviderStateMixin {
  final SubstitutionsFetcher substitutionsFetcher = client
      .applets![SPHAppEnum.vertretungsplan]!
      .fetchers[0] as SubstitutionsFetcher;

  final double padding = 12.0;

  List<GlobalKey<RefreshIndicatorState>> globalKeys = [
    GlobalKey<RefreshIndicatorState>()
  ];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    substitutionsFetcher.fetchData();
  }

  Widget noticeWidget(int entriesLength) {
    String title =
        entriesLength != 0 ? "Keine weiteren Einträge!" : "Keine Einträge!";
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 22)),
      subtitle: const Text(
          "Alle Angaben ohne Gewähr. \nDie Funktionalität der App hängt stark von der verwendeten Schule und den eingestellten Filtern ab. Einige Einträge können auch merkwürdig aussehen, da deine Schule möglicherweise nicht alle Einträge vollständig angibt."),
    );
  }

  List<Widget> getSubstitutionViews(dynamic data) {
    List<Widget> substitutionViews = [];

    for (int dayIndex = 0; dayIndex < data["length"]; dayIndex++) {
      final int entriesLength = data["days"][dayIndex]["entries"].length;

      substitutionViews.add(RefreshIndicator(
        key: globalKeys[dayIndex + 1],
        onRefresh: () async {
          substitutionsFetcher.fetchData(forceRefresh: true);
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
                    child: noticeWidget(entriesLength),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: SubstitutionWidget(
                      substitutionData: data["days"][dayIndex]["entries"]
                          [entryIndex]),
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
      errorWidgets.add(ErrorView.fromCode(
        data: data,
        name: "Vertretungsplan",
        fetcher: substitutionsFetcher,
      ));
    }

    return errorWidgets;
  }

  List<Tab> getTabs(dynamic fullVplan) {
    List<Tab> tabs = [];

    for (Map day in fullVplan["days"]) {
      String entryCount = day["entries"].length.toString();
      tabs.add(Tab(
        icon: Badge(
          label: Text(entryCount),
          child: const Icon(Icons.calendar_today),
        ),
        text: formatDate(day["date"]),
      ));
    }

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FetcherResponse>(
        stream: substitutionsFetcher.stream,
        builder: (context, snapshot) {
          if (snapshot.data?.status == FetcherStatus.error &&
              snapshot.data?.content ==
                  CredentialsIncompleteException().cause) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeLoginScreen()));
            });
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data?.status == FetcherStatus.fetching) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // GlobalKeys for RefreshIndicator and Refresh-FAB
          globalKeys += List.generate(snapshot.data?.content["length"],
              (index) => GlobalKey<RefreshIndicatorState>());

          // If there are no entries.
          if (snapshot.data?.content["length"] == 0) {
            return RefreshIndicator(
              key: globalKeys[0],
              onRefresh: () async {
                substitutionsFetcher.fetchData(forceRefresh: true);
              },
              child: const CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_dissatisfied, size: 60),
                        Padding(
                          padding: EdgeInsets.all(35),
                          child: Text("Es gibt keine Vertretungen!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              )),
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
              for (GlobalKey<RefreshIndicatorState> globalKey in globalKeys)
                {globalKey.currentState?.show()}
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
              substitutionsFetcher.fetchData();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => FilterPlan()))
                  .then((_) => setState(() {
                        substitutionsFetcher.fetchData(forceRefresh: true);
                      }));
            },
            child: const Icon(Icons.filter_alt),
          ),
        ],
      ),
    );
  }
}

String formatDate(String dateString) {
  final inputFormat = DateFormat('dd.MM.yyyy');
  final dateTime = inputFormat.parse(dateString);

  final germanFormat = DateFormat('E dd.MM.yyyy', 'de');
  return germanFormat.format(dateTime);
}
