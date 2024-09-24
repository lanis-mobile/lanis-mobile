import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/shared/types/lesson.dart';

import '../../client/client.dart';
import '../../shared/widgets/format_text.dart';

class HomeworkBox extends StatefulWidget {
  CurrentEntry currentEntry;
  final String courseID;
  HomeworkBox({super.key, required this.currentEntry, required this.courseID});

  @override
  State<HomeworkBox> createState() => _HomeworkBoxState();
}

class _HomeworkBoxState extends State<HomeworkBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primary,
          borderRadius:
          BorderRadius.circular(12)),
      margin: const EdgeInsets.only(
          top: 8, bottom: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 12, top: 4, bottom: 4),
                child: Row(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(
                          right: 8),
                      child: Icon(
                        Icons.task,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(
                          context)!
                          .homework,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                          color: Theme.of(
                              context)
                              .colorScheme
                              .onPrimary),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: widget.currentEntry.homework!.homeWorkDone, // Set the initial value as needed
                side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary,
                    width: 2),
                onChanged: (bool? value) {
                  try {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        content: Text(
                            AppLocalizations.of(
                                context)!
                                .homeworkSaving),
                        duration:
                        const Duration(
                            milliseconds:
                            500)));
                    client.meinUnterricht.setHomework(widget.courseID, widget.currentEntry.entryID, value!)
                        .then((val) {
                      if (val != "1") {
                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                            SnackBar(
                              content: Text(
                                  AppLocalizations.of(
                                      context)!
                                      .homeworkSavingError),
                            ));
                      } else {
                        setState(() {
                          widget.currentEntry.homework!.homeWorkDone =value;
                        });
                      }
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                      content: Text(
                          AppLocalizations.of(
                              context)!
                              .homeworkSavingError),
                    ));
                  }
                },
              ),
            ],
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .cardColor
                    .withOpacity(0.85),
                borderRadius:
                BorderRadius.circular(12)),
            padding: const EdgeInsets.all(12.0),
            child: FormattedText(
              text: widget.currentEntry.homework!.description,
              formatStyle: DefaultFormatStyle(context: context),
            ),
          )
        ],
      ),
    );
  }
}
