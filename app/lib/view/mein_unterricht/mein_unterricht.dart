import 'package:flutter/material.dart';
import 'package:sph_plan/client/fetcher.dart';
import '../../client/client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../shared/types/lesson.dart';
import '../../shared/widgets/error_view.dart';
import 'attendances.dart';
import 'lesson_list_tile.dart';

class MeinUnterrichtAnsicht extends StatefulWidget {
  const MeinUnterrichtAnsicht({super.key});

  @override
  State<StatefulWidget> createState() => _MeinUnterrichtAnsichtState();
}

class _MeinUnterrichtAnsichtState extends State<MeinUnterrichtAnsicht> with TickerProviderStateMixin {
  final MeinUnterrichtFetcher fetcher = client.fetchers.meinUnterrichtFetcher;

  Widget noDataScreen(context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.search,
              size: 60,
            ),
            Text(AppLocalizations.of(context)!.noCoursesFound)
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    fetcher.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FetcherResponse<Lessons>>(
      stream: fetcher.stream,
      builder: (BuildContext context,
          AsyncSnapshot<FetcherResponse<Lessons>> snapshot) {
        if (snapshot.data?.status == FetcherStatus.fetching) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data?.status == FetcherStatus.error) {
          return ErrorView(
            error: snapshot.data!.error!,
            name: 'Ups.',
          );
        }
        if (snapshot.data?.content == null ||
            snapshot.data!.content!.isEmpty) {
          return noDataScreen(context);
        }
        Lessons lessons = snapshot.data!.content!;
        Lessons attendanceLessons = lessons.where((element) => element.attendances != null).toList();

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => fetcher.fetchData(forceRefresh: true),
            child: ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: index == lessons.length - 1
                    ? const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 80)
                    : const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: LessonListTile(lesson: lessons[index]),
              ),
            ),
          ),
          floatingActionButton: Visibility(
            visible: attendanceLessons.isNotEmpty,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendancesScreen(lessons: attendanceLessons),
                  ),
                );
              },
              label: Text(AppLocalizations.of(context)!.attendances),
              icon: const Icon(Icons.access_alarm),
            ),
          ),
        );
      },
    );
  }
}
