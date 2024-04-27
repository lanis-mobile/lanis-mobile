import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/client/client_submodules/substitutions.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:sph_plan/shared/widgets/substitutions/substitutions_gridtile.dart';
import 'package:sph_plan/shared/widgets/substitutions/substitutions_listtile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../client/client.dart';
import '../../shared/widgets/error_view.dart';

class VertretungsplanAnsicht extends StatefulWidget {
  const VertretungsplanAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _VertretungsplanAnsichtState();
}

class _VertretungsplanAnsichtState extends State<VertretungsplanAnsicht>
    with TickerProviderStateMixin {
  final SubstitutionsFetcher substitutionsFetcher =
      client.fetchers.substitutionsFetcher;

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
    String title = entriesLength != 0
        ? AppLocalizations.of(context)!.noFurtherEntries
        : AppLocalizations.of(context)!.noEntries;
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 22)),
      subtitle: Text(AppLocalizations.of(context)!.substitutionsEndCardMessage),
    );
  }

  List<Widget> getSubstitutionViews(SubstitutionPlan substitutionPlan) {
    double deviceWidth = MediaQuery.of(context).size.width;

    List<Widget> substitutionViews = [];

    for (int dayIndex = 0;
        dayIndex < substitutionPlan.days.length;
        dayIndex++) {
      final int entriesLength =
          substitutionPlan.days[dayIndex].substitutions.length;

      substitutionViews.add(RefreshIndicator(
        key: globalKeys[dayIndex + 1],
        onRefresh: () async {
          substitutionsFetcher.fetchData(forceRefresh: true);
        },
        child: Padding(
          padding: EdgeInsets.only(left: padding, right: padding, top: padding),
          child: (deviceWidth > 505)
              ? GridView.builder(
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

                    return Card(
                      child: SubstitutionGridTile(
                          substitutionData: substitutionPlan
                              .days[dayIndex].substitutions[entryIndex]),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 500, childAspectRatio: 20 / 11),
                )
              : ListView.builder(
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
                        child: SubstitutionListTile(
                            substitutionData: substitutionPlan
                                .days[dayIndex].substitutions[entryIndex]),
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
        name: AppLocalizations.of(context)!.substitutions,
        fetcher: substitutionsFetcher,
      ));
    }

    return errorWidgets;
  }

  List<Tab> getTabs(SubstitutionPlan fullVplan) {
    List<Tab> tabs = [];

    for (SubstitutionDay day in fullVplan.days) {
      String entryCount = day.substitutions.length.toString();
      tabs.add(Tab(
        icon: Badge(
          label: Text(entryCount),
          child: const Icon(Icons.calendar_today),
        ),
        text: formatDate(day.date),
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
          if (snapshot.hasError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60),
                Padding(
                  padding: const EdgeInsets.all(35),
                  child: Text(
                    AppLocalizations.of(context)!.errorOccurred,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ));
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data?.status == FetcherStatus.fetching) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // GlobalKeys for RefreshIndicator and Refresh-FAB
          globalKeys += List.generate(snapshot.data?.content.days.length,
              (index) => GlobalKey<RefreshIndicatorState>());

          // If there are no entries.
          if (snapshot.data?.content.days.length == 0) {
            return RefreshIndicator(
              key: globalKeys[0],
              onRefresh: () async {
                substitutionsFetcher.fetchData(forceRefresh: true);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.sentiment_dissatisfied, size: 60),
                        Padding(
                          padding: const EdgeInsets.all(35),
                          child: Text(AppLocalizations.of(context)!.noEntries,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
              length: snapshot.data?.content.days.length, vsync: this);

          return Column(
            children: [
              TabBar(
                  isScrollable: true,
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
