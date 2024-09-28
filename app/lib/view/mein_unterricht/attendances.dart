import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/types/lesson.dart';

class AttendancesScreen extends StatelessWidget {
  const AttendancesScreen({super.key, required this.lessons});

  final Lessons lessons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.attendances),
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        lesson.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                          "${lesson.teacherKuerzel ?? lesson.teacher ?? '???'} "),
                      const Icon(
                        Icons.person,
                        size: 16,
                      ),
                    ],
                  ),
                  ...lesson.attendances!.entries.indexed.map(
                        (val) {
                      final index = val.$1;
                      final entry = val.$2;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: index.isEven
                              ? Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.3)
                              : Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.1),
                          borderRadius: index == 0
                              ? const BorderRadius.vertical(
                              top: Radius.circular(8))
                              : index == lesson.attendances!.length - 1
                              ? const BorderRadius.vertical(
                              bottom: Radius.circular(8))
                              : null,
                        ),
                        child: Row(
                          children: [
                            Text(entry.key,
                                style: Theme.of(context).textTheme.bodyMedium),
                            const Spacer(),
                            Text(
                              entry.value,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
