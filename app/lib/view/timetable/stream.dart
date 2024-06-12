import 'package:flutter/material.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:sph_plan/view/timetable/view.dart';

import '../../client/client.dart';

/// Timetable Widget utilizing the [TimeTableFetcher].
class TimetableView extends StatefulWidget {
  const TimetableView({super.key});

  @override
  State<StatefulWidget> createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView> {
  final TimeTableFetcher timetableFetcher = client.fetchers.timeTableFetcher;

  @override
  void initState() {
    super.initState();
    timetableFetcher.fetchData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FetcherResponse>(
        stream: timetableFetcher.stream,
        builder: (context, snapshot) {
      if (snapshot.data?.status == FetcherStatus.error) {
        return StaticTimetableView(
          lanisException: snapshot.data?.error,
          fetcher: timetableFetcher,
          refresh: () => timetableFetcher.fetchData(forceRefresh: true),
          loading: false,
        );
      }
        return StaticTimetableView(
            refresh: () => timetableFetcher.fetchData(forceRefresh: true),
            loading: snapshot.data?.status == FetcherStatus.fetching || snapshot.data?.status == null,
            data: snapshot.data?.content,
            fetcher: timetableFetcher,
          );
        },
      )
    );
  }
}

