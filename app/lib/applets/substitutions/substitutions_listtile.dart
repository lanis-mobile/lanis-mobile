import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sph_plan/widgets/marquee.dart';

import '../../models/substitution.dart';

class NotchEntry {
  final String label;
  final Widget widget;

  const NotchEntry(this.label, this.widget);
}

class SubstitutionDividedCard extends StatelessWidget {
  final List<NotchEntry> notchEntries;
  final List<String> notices;

  const SubstitutionDividedCard({
    super.key,
    required this.notchEntries,
    required this.notices});

  int get _colNotchLength => notchEntries.length % 2 == 0 ? notchEntries.length ~/ 2 : (notchEntries.length / 3).ceil();
  int get _colLength => notices.length + _colNotchLength;

  int get _takeCount => notchEntries.length % 2 == 0 ? 2 : 3;

  BorderRadius getVerticalRadius(int index) {
    if (index == 0 && _colLength == 1) {
      return BorderRadius.circular(12.0);
    } else if (index == 0) {
      return BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      );
    } else if (index == _colLength - 1) {
      return BorderRadius.only(
        bottomLeft: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      );
    } else {
      return BorderRadius.zero;
    }
  }

  BorderRadius getHorizontalRadius(int colIndex, int rowIndex, int rowLength) {
    if (rowIndex == 0 && rowLength > 1) {
      return BorderRadius.only(
          topLeft: colIndex == 0 ? Radius.circular(12.0) : Radius.zero,
          bottomLeft: colIndex == _colLength
              ? Radius.circular(12.0)
              : Radius.zero);
    } else if (rowIndex == 0) {
      return BorderRadius.circular(12.0);
    } else if (rowIndex == rowLength - 1) {
      return BorderRadius.only(
        topRight: colIndex == 0 ? Radius.circular(12.0) : Radius.zero,
        bottomRight: colIndex == _colLength
            ? Radius.circular(12.0)
            : Radius.zero,
      );
    } else {
      return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<NotchEntry> tempNotchEntries = List.from(notchEntries);

    return Column(
      spacing: 2.0,
      children: List<Widget>.generate(
          _colNotchLength,
          (colIndex) {
            final rowLength = tempNotchEntries.take(_takeCount).length;

            return Row(
              spacing: 2.0,
              children: List<Widget>.generate(
                  rowLength,
                  (rowIndex) {
                      final entry = tempNotchEntries.removeAt(0);

                      return Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: getHorizontalRadius(colIndex, rowIndex, rowLength),
                            color: Theme.of(context).colorScheme.surfaceContainer,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: Column(
                              children: [
                                Text(
                                  entry.label,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                MarqueeWidget(
                                  curve: Curves.linear,
                                  outCurve: Curves.linear,
                                  animationDuration: entry.widget is Text ? Duration(
                                      milliseconds: (3000 +
                                          clampDouble(
                                              (entry.widget as Text).data!.length *
                                                  100 -
                                                  3000,
                                              0,
                                              10000))
                                          .round()) : const Duration(milliseconds: 6000),
                                  child: DefaultTextStyle(
                                      style: Theme.of(context).textTheme.titleMedium!,
                                      child: entry.widget
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  }
              )
            );
          }
      )+List<Widget>.generate(
          notices.length,
          (index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: getVerticalRadius(_colNotchLength + index),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  spacing: 8.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                    ),
                    Flexible(child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                          notices[index],
                          style: Theme.of(context).textTheme.bodyMedium
                      ),
                    ))
                  ],
                ),
              ),
            );
          }
      )
    );
  }
}

class SubstitutionTile extends StatelessWidget {
  final Substitution substitutionData;
  const SubstitutionTile({super.key, required this.substitutionData});

  bool doesExist(String? info) {
    List empty = [null, "", " ", "-", "---"];
    return !empty.contains(info);
  }

  bool doesExistList(List<String?> info) {
    List empty = [null, "", " ", "-", "---"];
    return info.any((element) => !empty.contains(element));
  }

  String removeHtmlTags(String data) {
    return data.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    Substitution data = substitutionData;

    return SubstitutionDividedCard(
        notchEntries: [
          if (doesExist(data.klasse))
            NotchEntry("Klasse", Text(data.klasse!)),
          if (doesExist(data.fach))
            NotchEntry("Fach", Text(data.fach!)),
          if (doesExist(data.art))
            NotchEntry("Art", Text(data.art!)),
          if (doesExist(data.stunde))
            NotchEntry("Stunde", Text(data.stunde)),
          if (doesExist(data.vertreter) || doesExist(data.lehrer))
            NotchEntry("Lehrer", Row(
              children: [
                if (doesExist(data.lehrer)) Text(
                  removeHtmlTags(data.lehrer!),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                if (doesExist(data.lehrer) && doesExist(data.vertreter)) Icon(Icons.chevron_right, size: 20),
                if (doesExist(data.vertreter)) Text(removeHtmlTags(data.vertreter!)),
              ],
            )),
          if (doesExist(data.raum))
            NotchEntry("Raum", Text(data.raum!)),
        ],
        notices: [
          if (doesExist(substitutionData.hinweis)) substitutionData.hinweis!,
          if (doesExist(substitutionData.hinweis2)) substitutionData.hinweis2!,
        ]
    );
  }
}

/// Takes a string with eventual html tags and applies the necessary formatting according to the tags.
/// Tags may only occur at the beginning or end of the string.
///
/// Tags include: <b>, <i>, <del>
class SubstitutionsFormattedText extends StatelessWidget {
  final String data;
  final TextStyle style;

  const SubstitutionsFormattedText(this.data, this.style, {super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(text: _format(data, style));
  }

  TextSpan _format(String data, TextStyle style) {
    if (data.startsWith("<b>") && data.endsWith("</b>")) {
      return TextSpan(
          text: data.substring(3, data.length - 4),
          style: style.copyWith(fontWeight: FontWeight.bold));
    } else if (data.startsWith("<i>") && data.endsWith("</i>")) {
      return TextSpan(
          text: data.substring(3, data.length - 4),
          style: style.copyWith(fontStyle: FontStyle.italic));
    } else if (data.startsWith("<del>") && data.endsWith("</del>")) {
      return TextSpan(
          text: data.substring(5, data.length - 6),
          style: style.copyWith(decoration: TextDecoration.lineThrough));
    } else {
      return TextSpan(text: data, style: style);
    }
  }
}
