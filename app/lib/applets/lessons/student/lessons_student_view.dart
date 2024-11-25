import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/applets/lessons/definition.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';
import '../../../core/sph/sph.dart';
import '../../../models/lessons.dart';
import 'attendances.dart';
import 'lesson_list_tile.dart';

class LessonsStudentView extends StatefulWidget {
  const LessonsStudentView({super.key});

  @override
  State<StatefulWidget> createState() => _LessonsStudentViewState();
}

class _LessonsStudentViewState extends State<LessonsStudentView> with TickerProviderStateMixin {

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
  Widget build(BuildContext context) {
    return CombinedAppletBuilder<Lessons>(
        parser: sph!.parser.lessonsStudentParser,
        phpUrl: lessonsDefinition.appletPhpUrl,
        settingsDefaults: lessonsDefinition.settingsDefaults,
        accountType: sph!.session.accountType,
        builder: (context, lessons, accountType, settings, updateSetting, refresh) {
          if (lessons.isEmpty) return noDataScreen(context);
          Lessons attendanceLessons = lessons.where((element) => element.attendances != null).toList();

          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () => refresh!(),
              child: ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: index == lessons.length - 1
                      ? const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 80)
                      : const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
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
