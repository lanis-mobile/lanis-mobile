import 'package:flutter/material.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:sph_plan/shared/apps.dart';

import '../../client/client.dart';

class TimetableAnsicht extends StatefulWidget {
  const TimetableAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _TimetableAnsichtState();
}

class _TimetableAnsichtState extends State<TimetableAnsicht>
    with TickerProviderStateMixin {
  final TimeTableFetcher timetableFetcher = client
      .applets![SPHAppEnum.stundenplan]!
      .fetchers[0] as TimeTableFetcher;


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
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: [
              Text(snapshot.data!.content.toString())
            ],
          );
        },
      ),
    );
  }
}
