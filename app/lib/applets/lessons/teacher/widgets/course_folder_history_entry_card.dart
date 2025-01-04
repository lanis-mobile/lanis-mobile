import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/applets/lessons/teacher/widgets/right_bottom_card_button.dart';
import 'package:sph_plan/applets/lessons/teacher/widgets/upload_file_to_course_chip.dart';

import '../../../../models/lessons_teacher.dart';
import 'course_folder_history_entry_file_chip.dart';
import 'line_constraint_text.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseFolderHistoryEntryCard extends StatefulWidget {
  final CourseFolderHistoryEntry entry;
  final String courseId;
  const CourseFolderHistoryEntryCard({super.key, required this.entry, required this.courseId});

  @override
  State<CourseFolderHistoryEntryCard> createState() => _CourseFolderHistoryEntryCardState();
}

class _CourseFolderHistoryEntryCardState extends State<CourseFolderHistoryEntryCard> {
  bool _showFiles = false;

  bool get _isToday {
    final now = DateTime.now();
    return widget.entry.date.year == now.year && widget.entry.date.month == now.month && widget.entry.date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, top: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.schedule, size: 18),
                            SizedBox(width: 4),
                            Text(AppLocalizations.of(context)!.dateWithHours(DateFormat.yMEd(Localizations.localeOf(context).toString()).format(widget.entry.date), widget.entry.schoolHours)),
                            if (_isToday) ...[
                              SizedBox(width: 4),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text('Heute',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ],
                        ),
                        LineConstraintText(
                          data: widget.entry.topic,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  iconSize: 20,
                  onSelected: (String value) {
                    switch (value) {
                      case 'Eintrag löschen':
                        break;
                      case 'Eintrag bearbeiten':
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Eintrag löschen', 'Eintrag bearbeiten'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Row(
                          children: [
                            Icon(choice == 'Eintrag löschen' ? Icons.delete : Icons.edit),
                            const SizedBox(width: 4.0),
                            Text(choice),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
              child: Column(
                children: [
                  if (widget.entry.content != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: widget.entry.homework == null ? Radius.circular(8) : Radius.zero,
                          bottomRight: widget.entry.homework == null ? Radius.circular(8) : Radius.zero,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(Icons.topic,
                              color: Theme.of(context).colorScheme.onTertiaryContainer),
                          const SizedBox(width: 8),
                          Expanded(
                              child: LineConstraintText(
                                data: widget.entry.content!,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                  if (widget.entry.homework != null) ...[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: widget.entry.content == null ? Radius.circular(8) : Radius.zero,
                          topRight: widget.entry.content == null ? Radius.circular(8) : Radius.zero,
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(Icons.task,
                              color: Theme.of(context).colorScheme.onPrimary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LineConstraintText(
                              data: widget.entry.homework!,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ],
              ),
            ),
            Row(
              children: [
                Spacer(),
                RightBottomCardButton(
                  text: 'Noten',
                  icon: Icons.star_border,
                  color: Colors.grey.shade300,
                  onColor: Colors.grey.shade900,
                  onTap: () {},
                  topLeftNotRounded: false,
                  bottomRightNotRounded: true,
                ),
                RightBottomCardButton(
                  text: 'Anwesenheiten️',
                  icon: widget.entry.attendanceActionRequired ? Icons.error : Icons.list_alt,
                  color: widget.entry.attendanceActionRequired ? Colors.red.shade100 : Colors.blue.shade100,
                  onColor: widget.entry.attendanceActionRequired ? Colors.red.shade900 : Colors.blue.shade900,
                  onTap: () {},
                  topLeftNotRounded: true,
                  bottomRightNotRounded: true,
                ),
                RightBottomCardButton(
                  text: widget.entry.studentUploadFileCount,
                  icon: Icons.download,
                  color: Colors.amber.shade100,
                  onColor: Colors.amber.shade900,
                  onTap: () {},
                  topLeftNotRounded: true,
                  bottomRightNotRounded: true,
                ),
                RightBottomCardButton(
                  text: widget.entry.files.length.toString(),
                  onTap: () {
                    setState(() {
                      _showFiles = !_showFiles;
                    });
                  },
                  topLeftNotRounded: true,
                  onColor: Colors.green.shade900,
                  icon: Icons.attach_file,
                  color: Colors.green.shade100,
                  isExpanded: _showFiles,
                ),
              ],
            ),
            if (_showFiles) ... [
              Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 12.0, left: 12.0),
                child: Wrap(
                  spacing: 4.0,
                  alignment: WrapAlignment.start,
                  children: [
                    SizedBox(width: double.infinity,),
                    ...widget.entry.files.map((file) => CourseFolderHistoryEntryFileChip(
                      file: file,
                      courseId: widget.courseId,
                      onVisibilityChanged: (bool isVisible) {
                        setState(() {
                          file.isVisibleForStudents = isVisible;
                        });
                      },
                      onFileDeleted: () {
                        setState(() {
                          widget.entry.files.remove(file);
                        });
                      },
                    )),
                    UploadFileToCourseChip(
                      courseId: widget.courseId,
                      entryId: widget.entry.id,
                      onFileUploaded: (List<CourseFolderHistoryEntryFile> files) {
                        setState(() {
                          widget.entry.files.addAll(files);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
