import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/lessons_teacher.dart';
import 'line_constraint_text.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseFolderHistoryEntryCard extends StatefulWidget {
  final CourseFolderHistoryEntry entry;
  const CourseFolderHistoryEntryCard({super.key, required this.entry});

  @override
  State<CourseFolderHistoryEntryCard> createState() => _CourseFolderHistoryEntryCardState();
}

class _CourseFolderHistoryEntryCardState extends State<CourseFolderHistoryEntryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.entry.topic),
        subtitle: Column(
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
            Row(
              children: [
                Icon(Icons.schedule, size: 18),
                SizedBox(width: 4),
                Text(AppLocalizations.of(context)!.dateWithHours(DateFormat('dd.MM.yy').format(widget.entry.date), widget.entry.schoolHours)),
              ],
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {},
      ),
    );
  }
}
