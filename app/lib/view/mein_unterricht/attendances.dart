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
            child: ListTile(
              title: Row(
                children: [
                  Text(lesson.name, overflow: TextOverflow.ellipsis,),
                  const Spacer(),
                  Text("${lesson.teacherKuerzel ?? lesson.teacher ?? '???'} "),
                  const Icon(Icons.person, size: 16,),
                ],
              ),
              subtitle: Column(
                children: lesson.attendances!.entries.indexed.map((val) {
                  //(index, entry)
                  final index = val.$1;
                  final entry = val.$2;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    color: index.isEven
                        ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
                        : Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                    child: Row(
                      children: [
                        Text(entry.key, style: Theme.of(context).textTheme.bodyMedium),
                        const Spacer(),
                        Text(entry.value, style: Theme.of(context).textTheme.bodyMedium,),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
