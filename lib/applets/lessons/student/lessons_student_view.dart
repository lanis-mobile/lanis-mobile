import 'package:flutter/material.dart';
import 'package:lanis/generated/l10n.dart';
import 'package:lanis/applets/lessons/definition.dart';
import 'package:lanis/widgets/combined_applet_builder.dart';
import 'package:lanis/widgets/dynamic_app_bar.dart';

import '../../../core/sph/sph.dart';
import '../../../models/lessons.dart';
import 'attendances.dart';
import 'lesson_list_tile.dart';

class LessonsStudentView extends StatefulWidget {
  final Function? openDrawerCb;
  const LessonsStudentView({super.key, this.openDrawerCb});

  @override
  State<StatefulWidget> createState() => _LessonsStudentViewState();
}

class _LessonsStudentViewState extends State<LessonsStudentView>
    with TickerProviderStateMixin {
  Widget noDataScreen(context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.search,
              size: 60,
            ),
            Text(AppLocalizations.of(context).noCoursesFound)
          ],
        ),
      );

  Map<String, dynamic>? globalSettings;
  Future<void> Function(String, dynamic)? globalUpdateSetting;
  Lessons? homeworkLessons;

  Widget buildAppBarActionToggle(BuildContext context) {
    if (globalSettings != null &&
        globalUpdateSetting != null &&
        homeworkLessons != null &&
        homeworkLessons!.isNotEmpty) {
      final showHomework = globalSettings!['showHomework'] == true;
      return Tooltip(
        message: showHomework
            ? AppLocalizations.of(context).lessons
            : AppLocalizations.of(context).homework,
        child: IconButton(
          icon: Icon(
            showHomework ? Icons.school_outlined : Icons.task_outlined,
          ),
          onPressed: () {
            globalUpdateSetting!(
              'showHomework',
              !showHomework,
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });
          },
        ),
      );
    }
    return SizedBox.shrink();
  }

  void updateAppBarActions(Widget action) {
    AppBarController.instance.removeAction('lessonsStudentView');
    AppBarController.instance.addAction(
      'lessonsStudentView',
      action,
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppBarController.instance.removeAction('lessonsStudentView');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CombinedAppletBuilder<Lessons>(
      parser: sph!.parser.lessonsStudentParser,
      phpUrl: lessonsDefinition.appletPhpIdentifier,
      settingsDefaults: lessonsDefinition.settingsDefaults,
      accountType: sph!.session.accountType,
      builder:
          (context, lessons, accountType, settings, updateSetting, refresh) {
        Lessons? attendanceLessons;
        homeworkLessons = lessons
            .where((element) => element.currentEntry?.homework != null)
            .toList();

        globalUpdateSetting = updateSetting;
        globalSettings = settings;
        if (settings['showHomework'] == true && homeworkLessons!.isEmpty) {
          updateSetting('showHomework', false);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          updateAppBarActions(
            buildAppBarActionToggle(context),
          );
        });

        if (settings['showHomework'] == true) {
          lessons = homeworkLessons!;

          lessons.sort((a, b) {
            if (a.currentEntry!.homework!.homeWorkDone ==
                b.currentEntry?.homework?.homeWorkDone) {
              if (a.currentEntry?.topicDate != null &&
                  b.currentEntry?.topicDate != null) {
                return a.currentEntry!.topicDate!
                    .compareTo(b.currentEntry!.topicDate!);
              } else {
                return a.currentEntry?.topicDate == null ? 1 : -1;
              }
            }
            return (a.currentEntry?.homework?.homeWorkDone ?? false) ? 1 : -1;
          });
        } else {
          attendanceLessons =
              lessons.where((element) => element.attendances != null).toList();
        }

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => refresh!(),
            child: lessons.isNotEmpty
                ? ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: EdgeInsets.only(
                        top: 0,
                        bottom: 4 + (index == lessons.length - 1 ? 80 : 0),
                        left: 8,
                        right: 8,
                      ),
                      child: LessonListTile(lesson: lessons[index]),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      noDataScreen(context),
                    ],
                  ),
          ),
          floatingActionButton: Visibility(
            visible: attendanceLessons != null && attendanceLessons.isNotEmpty,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AttendancesScreen(lessons: attendanceLessons!),
                  ),
                );
              },
              label: Text(AppLocalizations.of(context).attendances),
              icon: const Icon(Icons.access_alarm),
            ),
          ),
        );
      },
    );
  }
}
