import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import '../../client/client.dart';
import '../../shared/apps.dart';
import '../../shared/errorView.dart';
import '../login/screen.dart';
import 'course_overview.dart';

class MeinUnterrichtAnsicht extends StatefulWidget {
  const MeinUnterrichtAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _MeinUnterrichtAnsichtState();
}

class _MeinUnterrichtAnsichtState extends State<MeinUnterrichtAnsicht>
    with TickerProviderStateMixin {
  final MeinUnterrichtFetcher meinUnterrichtFetcher = client.applets![SPHAppEnum.meinUnterricht]!.fetchers[0] as MeinUnterrichtFetcher;

  static const double padding = 12.0;
  late TabController _tabController;

  final GlobalKey<RefreshIndicatorState> _currentIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _coursesIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _presenceIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  final Widget noDataScreen = const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.search,
          size: 60,
        ),
        Text("Keine Kurse gefunden.")
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    meinUnterrichtFetcher.fetchData();
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
        meinUnterrichtFetcher.fetchData(forceRefresh: true);
      },
      child: presence.length != 0 ? ListView.builder(
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
                children: [
                  Text(
                      toBeginningOfSentenceCase("$key:")!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(value)
                ],
              ));
            }
          });

          return Padding(
              padding: EdgeInsets.only(
                left: padding,
                right: padding,
                bottom: index == presence.length - 1 ? 14 : 8,
                top: index == 0 ? padding : 0,
              ),
              child: Card(
                child: ListTile(
                  title: Text(
                      presence[index]["Kurs"] ?? "",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
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
                            dataFetchURL: presence[index]["_courseURL"],
                            title: presence[index]["Kurs"],
                          )),
                    );
                  },
                ),
              ));
        },
      ) : noDataScreen
    );
  }

  Widget coursesView(BuildContext context, dynamic courses) {
    return RefreshIndicator(
      key: _coursesIndicatorKey,
      onRefresh: () async {
        meinUnterrichtFetcher.fetchData(forceRefresh: true);
      },
      child: courses.length != 0 ? ListView.builder(
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.only(
                left: padding,
                right: padding,
                bottom: index == courses.length - 1 ? 14 : 8,
                top: index == 0 ? padding : 0,
              ),
              child: Card(
                child: ListTile(
                  title: Text(
                      courses[index]["title"] ?? "",
                      style: Theme.of(context).textTheme.titleMedium
                  ),
                  subtitle: Text(
                      courses[index]["teacher"] ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CourseOverviewAnsicht(
                            dataFetchURL: courses[index]["_courseURL"],
                            title: courses[index]["title"],
                          )),
                    );
                  },
                ),
              ));
        },
      ) : noDataScreen,
    );
  }

  Widget currentView(BuildContext context, dynamic current) {
    return RefreshIndicator(
      key: _currentIndicatorKey,
      onRefresh: () async {
        meinUnterrichtFetcher.fetchData(forceRefresh: true);
      },
      child: current.length != 0 ? ListView.builder(
        itemCount: current.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.only(
                  left: padding,
                  right: padding,
                  bottom: index == current.length - 1 ? 14 : 8,
                  top: index == 0 ? padding : 0,
              ),
              child: Card(
                child: ListTile(
                  title: Text(
                      current[index]["name"] ?? "",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Thema: ${current[index]["thema"]["title"] ?? ""}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${current[index]["teacher"]["name"]??""} (${current[index]["teacher"]["short"] ?? "-"})",
                          ),
                          Text(current[index]["thema"]["date"]??"-")
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
                            dataFetchURL: current[index]["_courseURL"],
                            title: current[index]["name"],
                          )),
                    );
                  },
                ),
              ));
        },
      ) : noDataScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FetcherResponse>(
        stream: meinUnterrichtFetcher.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError &&
              snapshot.error is CredentialsIncompleteException) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeLoginScreen()));
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
                    if (snapshot.data?.status == FetcherStatus.error && snapshot.data?.content is LanisException) ...[
                      ErrorView(data: snapshot.data?.content as LanisException, name: "Mein Unterricht", fetcher: meinUnterrichtFetcher,),
                      ErrorView(data: snapshot.data?.content as LanisException, name: "Mein Unterricht", fetcher: meinUnterrichtFetcher),
                      ErrorView(data: snapshot.data?.content as LanisException, name: "Mein Unterricht", fetcher: meinUnterrichtFetcher)
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
    );
  }
}
