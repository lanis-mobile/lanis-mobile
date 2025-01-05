import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/applets/substitutions/definition.dart';
import 'package:sph_plan/applets/substitutions/substitutions_listtile.dart';
import 'package:sph_plan/models/substitution.dart';

import '../../core/sph/sph.dart';
import '../../widgets/combined_applet_builder.dart';
import 'substitutions_gridtile.dart';

class SubstitutionsView extends StatefulWidget {
  final Function? openDrawerCb;
  const SubstitutionsView({super.key, this.openDrawerCb});

  @override
  State<SubstitutionsView> createState() => _SubstitutionsViewState();
}

class _SubstitutionsViewState extends State<SubstitutionsView>
    with TickerProviderStateMixin {
  static const double padding = 12.0;

  List<GlobalKey<RefreshIndicatorState>> globalKeys = [
    GlobalKey<RefreshIndicatorState>()
  ];
  TabController? _tabController;

  Widget lastWidget({required int entriesLength, required DateTime lastEdit}) {
    return ListTile(
      title: Center(
        child: Text(AppLocalizations.of(context)!.noFurtherEntries,
            style: const TextStyle(fontSize: 22)),
      ),
      subtitle: Center(
        child: Text(
          AppLocalizations.of(context)!
              .substitutionsEndCardMessage(lastEdit.format('dd.MM.yyyy HH:mm')),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List<Widget> getSubstitutionViews(SubstitutionPlan substitutionPlan,
      RefreshFunction? refresh) {
    double deviceWidth = MediaQuery.of(context).size.width;

    List<Widget> substitutionViews = [];

    for (int dayIndex = 0;
        dayIndex < substitutionPlan.days.length;
        dayIndex++) {
      final int entriesLength =
          substitutionPlan.days[dayIndex].substitutions.length;

      substitutionViews.add(RefreshIndicator(
        key: globalKeys[dayIndex + 1],
        notificationPredicate: refresh != null
            ? (_) => true
            : (_) => false, // Hide refresh indicator without bloating the code
        onRefresh: refresh ?? () async {},
        child: Padding(
          padding: EdgeInsets.only(left: padding, right: padding, top: padding),
          child: Column(children: [
            if (_tabController != null &&
                substitutionPlan.days[dayIndex].infos != null) Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0, right: 8.0, left: 8.0),
              child: ElevatedButton(
                  onPressed: () => showSubstitutionInformation(
                      context, substitutionPlan.days[dayIndex].infos!),
                  child: Text(AppLocalizations.of(context)!
                      .substitutionsInformationMessage)),
            ),
            Expanded(
                child: (deviceWidth > 505)
                    ? GridView.builder(
                        itemCount: entriesLength + 1,
                        itemBuilder: (context, entryIndex) {
                          if (entryIndex == entriesLength) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: padding),
                              child: lastWidget(
                                  entriesLength: entriesLength,
                                  lastEdit: substitutionPlan.lastUpdated),
                            );
                          }

                          return Card(
                            child: SubstitutionGridTile(
                                substitutionData: substitutionPlan
                                    .days[dayIndex].substitutions[entryIndex]),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 500,
                                childAspectRatio: 20 / 11),
                      )
                    : ListView.builder(
                        itemCount: entriesLength + 1,
                        itemBuilder: (context, entryIndex) {
                          if (entryIndex == entriesLength) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: padding),
                              child: lastWidget(
                                  entriesLength: entriesLength,
                                  lastEdit: substitutionPlan.lastUpdated),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Card(
                              child: SubstitutionListTile(
                                  substitutionData: substitutionPlan
                                      .days[dayIndex]
                                      .substitutions[entryIndex]),
                            ),
                          );
                        },
                      ))
          ]),
        ),
      ));
    }

    return substitutionViews;
  }

  List<Tab> getTabs(SubstitutionPlan substitutionPlan) {
    List<Tab> tabs = [];

    for (SubstitutionDay day in substitutionPlan.days) {
      String entryCount = day.substitutions.length.toString();
      tabs.add(Tab(
        icon: Badge(
          label: Text(entryCount),
          child: const Icon(Icons.calendar_today),
        ),
        text: formatDate(day.parsedDate),
      ));
    }

    return tabs;
  }

  void showSubstitutionInformation(
      BuildContext context, List<SubstitutionInfo> infos) {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        showDragHandle: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: ListView(shrinkWrap: true, children: [
              ...infos.map((info) => Column(
                spacing: 4.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info.header,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SelectionArea(
                    child: HtmlWidget(
                      info.values.join('<br>'),
                      renderMode: RenderMode.column,
                    ),
                  ),
                  SizedBox(height: 8.0,),
                ],
              )),
            ]),
          );
        });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(substitutionDefinition.label(context)),
        leading: widget.openDrawerCb != null ? IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => widget.openDrawerCb!(),
        ) : null,
      ),
      body: CombinedAppletBuilder<SubstitutionPlan>(
        accountType: sph!.session.accountType,
        parser: sph!.parser.substitutionsParser,
        phpUrl: substitutionDefinition.appletPhpUrl,
        settingsDefaults: substitutionDefinition.settingsDefaults,
        builder: (context, data, accountType, settings, updateSetting, refresh) {
          if (data.days.isEmpty) {
            // GlobalKeys for RefreshIndicator and Refresh-FAB
            globalKeys += List.generate(
                data.days.length, (index) => GlobalKey<RefreshIndicatorState>());
            return RefreshIndicator(
              key: globalKeys[0],
              notificationPredicate: refresh != null ? (_) => true : (_) => false,
              onRefresh: refresh ?? () async {},
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
          } else {
            globalKeys += List.generate(
                data.days.length, (index) => GlobalKey<RefreshIndicatorState>());
            _tabController = TabController(length: data.days.length, vsync: this);

            return Column(
              children: [
                TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    tabs: getTabs(data)),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: getSubstitutionViews(data, refresh),
                  ),
                )
              ],
            );
          }
        },
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
