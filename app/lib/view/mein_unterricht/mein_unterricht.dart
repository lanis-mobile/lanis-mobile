import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sph_plan/client/fetcher.dart';
import '../../client/client.dart';
import '../bug_report/send_bugreport.dart';
import '../settings/subsettings/user_login.dart';
import 'course_overview.dart';

class MeinUnterrichtAnsicht extends StatefulWidget {
  const MeinUnterrichtAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _MeinUnterrichtAnsichtState();
}

class _MeinUnterrichtAnsichtState extends State<MeinUnterrichtAnsicht>
    with TickerProviderStateMixin {
  final double padding = 8.0;
  late TabController _tabController;

  final GlobalKey<RefreshIndicatorState> _mErrorIndicatorKey0 =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _mErrorIndicatorKey1 =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _mErrorIndicatorKey2 =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _currentIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _coursesIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _presenceIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    client.meinUnterrichtFetcher.fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget presenceView(BuildContext context, dynamic presence) {
    return RefreshIndicator(
      key: _presenceIndicatorKey,
      onRefresh: () async {
        client.meinUnterrichtFetcher.fetchData(forceRefresh: true);
      },
      child: ListView.builder(
        itemCount: presence.length,
        itemBuilder: (BuildContext context, int index) {
          List<String> keysNotRender = [
            "Kurs",
            "Lehrkraft",
            "_courseURL"
          ];
          List<Widget> rowChildren = [];

          presence[index].forEach((key, value) {
            if (!keysNotRender.contains(key) && value != "") {
              rowChildren.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("$key:"), Text(value)],
              ));
            }
          });

          return Padding(
              padding: EdgeInsets.only(
                  left: padding, right: padding, bottom: padding),
              child: Card(
                child: ListTile(
                  title: Text(presence[index]["Kurs"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rowChildren,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CourseOverviewAnsicht(
                            dataFetchURL: presence
                            [index]["_courseURL"],
                          )),
                    );
                  },
                ),
              ));
        },
      ),
    );
  }

  Widget coursesView(BuildContext context, dynamic courses) {
    return RefreshIndicator(
      key: _coursesIndicatorKey,
      onRefresh: () async {
        client.meinUnterrichtFetcher.fetchData(forceRefresh: true);
      },
      child: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.only(
                  left: padding, right: padding, bottom: padding),
              child: Card(
                child: ListTile(
                  title: Text(courses[index]["title"]),
                  subtitle: Text(courses[index]["teacher"]),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CourseOverviewAnsicht(
                            dataFetchURL: courses[index]
                            ["_courseURL"],
                          )),
                    );
                  },
                ),
              ));
        },
      ),
    );
  }

  Widget currentView(BuildContext context, dynamic current) {
    return RefreshIndicator(
      key: _currentIndicatorKey,
      onRefresh: () async {
        client.meinUnterrichtFetcher.fetchData(forceRefresh: true);
      },
      child: ListView.builder(
        itemCount: current.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.only(
                  left: padding, right: padding, bottom: padding),
              child: Card(
                child: ListTile(
                  title: Text(current[index]["name"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Thema: ${current[index]["thema"]["title"]}"),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${current[index]["teacher"]["short"]}-${current[index]["teacher"]["name"]}"),
                          Text(current[index]["thema"]["date"])
                        ],
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CourseOverviewAnsicht(
                            dataFetchURL: current[index]
                            ["_courseURL"],
                          )),
                    );
                  },
                ),
              ));
        },
      ),
    );
  }

  Widget errorView(BuildContext context, FetcherResponse? response, GlobalKey key) {
    return RefreshIndicator(
      key: key,
      onRefresh: () async {
        client.meinUnterrichtFetcher.fetchData(forceRefresh: true);
      },
      child: CustomScrollView(
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
                    "Problem: ${client.statusCodes[response!.content] ?? "Unbekannter Fehler"}"),
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
                                  builder: (context) => BugReportScreen(
                                      generatedMessage:
                                      "AUTOMATISCH GENERIERT:\nEin Fehler ist bei Mein Unterricht aufgetreten:\n${response.content}: ${client.statusCodes[response.content]}\n\nMehr Details von dir:\n")),
                            );
                          },
                          child:
                          const Text("Fehlerbericht senden")),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: OutlinedButton(
                            onPressed: () async {
                              client.meinUnterrichtFetcher
                                  .fetchData(forceRefresh: true);
                            },
                            child: const Text("Erneut versuchen")),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FetcherResponse>(
        stream: client.meinUnterrichtFetcher.stream,
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

          return Column(
            children: [
              TabBar(controller: _tabController, tabs: const [
                Tab(
                  icon: Icon(Icons.list),
                  text: "Aktuelles",
                ),
                Tab(icon: Icon(Icons.folder_copy), text: "Kursmappen"),
                Tab(
                  icon: Icon(Icons.calendar_today),
                  text: "Anwesenheiten",
                )
              ]),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    if (snapshot.data?.status == FetcherStatus.error) ...[
                      errorView(context, snapshot.data, _mErrorIndicatorKey0),
                      errorView(context, snapshot.data, _mErrorIndicatorKey1),
                      errorView(context, snapshot.data, _mErrorIndicatorKey2),
                    ]
                    else if (snapshot.data?.status == FetcherStatus.fetching || snapshot.data == null) ...[
                      const Center(child: CircularProgressIndicator()),
                      const Center(child: CircularProgressIndicator()),
                      const Center(child: CircularProgressIndicator()),
                    ]
                    else ...[
                      currentView(context, snapshot.data?.content["aktuell"]),
                      coursesView(context, snapshot.data?.content["kursmappen"]),
                      presenceView(context, snapshot.data?.content["anwesenheiten"]),
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
            onPressed: () {
              // Only visible key is refreshed, so it's ok.
              _mErrorIndicatorKey0.currentState?.show();
              _mErrorIndicatorKey1.currentState?.show();
              _mErrorIndicatorKey2.currentState?.show();
              _currentIndicatorKey.currentState?.show();
              _coursesIndicatorKey.currentState?.show();
              _presenceIndicatorKey.currentState?.show();
            },
            heroTag: "RefreshMeinUnterricht",
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
