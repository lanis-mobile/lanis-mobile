import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sph_plan/widgets/marquee.dart';

import '../../models/substitution.dart';

class DividedCard extends StatelessWidget {
  final List<Widget> children;
  final List<Widget> noMarqueeChildren;
  final double spacing;
  final EdgeInsets padding;
  final bool forceAlignment;

  const DividedCard(
      {super.key,
      required this.children,
      this.noMarqueeChildren = const [],
      this.spacing = 2.0,
      this.padding = const EdgeInsets.all(12.0),
      this.forceAlignment = false});

  BorderRadius getVerticalRadius(int index) {
    int length = children.length + noMarqueeChildren.length;
    if (index == 0 && length == 1) {
      return BorderRadius.circular(12.0);
    } else if (index == 0) {
      return BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      );
    } else if (index == length - 1) {
      return BorderRadius.only(
        bottomLeft: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      );
    } else {
      return BorderRadius.zero;
    }
  }

  BorderRadius getHorizontalRadius(int colIndex, int rowIndex, int length) {
    if (rowIndex == 0 && length > 1) {
      return BorderRadius.only(
          topLeft: colIndex == 0 ? Radius.circular(12.0) : Radius.zero,
          bottomLeft: colIndex == (children.length-1) + noMarqueeChildren.length
              ? Radius.circular(12.0)
              : Radius.zero);
    } else if (rowIndex == 0) {
      return BorderRadius.circular(12.0);
    } else if (rowIndex == length - 1) {
      return BorderRadius.only(
        topRight: colIndex == 0 ? Radius.circular(12.0) : Radius.zero,
        bottomRight: colIndex == (children.length-1) + noMarqueeChildren.length
            ? Radius.circular(12.0)
            : Radius.zero,
      );
    } else {
      return BorderRadius.zero;
    }
  }

  Alignment getAlignment(int index, int rowLength) {
    if (index == 0) {
      return Alignment.centerLeft;
    } else if (index == rowLength - 1) {
      return Alignment.centerRight;
    } else {
      return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: spacing,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(children.length, (index) {
        Widget child = children[index];
        if (child.runtimeType == Row) {
          Row row = child as Row;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 2.0,
            children: List.generate(row.children.length, (rowIndex) {
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: getHorizontalRadius(
                        index, rowIndex, row.children.length),
                    color:
                        Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Padding(
                    padding: padding,
                    child: forceAlignment
                        ? Align(
                            alignment:
                                getAlignment(rowIndex, row.children.length),
                            child: scrollItem(row.children[rowIndex]),
                          )
                        : scrollItem(row.children[rowIndex]),
                  ),
                ),
              );
            }),
          );
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: getVerticalRadius(index),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          child: Padding(
            padding: padding,
            child: scrollItem(child),
          ),
        );
      })
      +List.generate(noMarqueeChildren.length, (index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: getVerticalRadius(children.length+index),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          child: Padding(
            padding: padding,
            child: noMarqueeChildren[index],
          ),
        );
      }),
    );
  }

  Widget scrollItem(Widget child) {
    Widget originalChild = child;
    if (child.runtimeType == SizedBox) {
      child = (child as SizedBox).child!;
    }

    if (child.runtimeType == Row &&
        (child as Row).children.length == 2 &&
        child.children[0].runtimeType == Icon) {
      return Row(
        spacing: child.spacing,
        children: [
          child.children[0],
          Expanded(
            child: MarqueeWidget(
              curve: Curves.linear,
              outCurve: Curves.linear,
              animationDuration: (child.children[1].runtimeType == Text)
                  ? Duration(
                      milliseconds: (3000 +
                              clampDouble(
                                  (child.children[1] as Text).data!.length *
                                          100 -
                                      3000,
                                  0,
                                  10000))
                          .round())
                  : const Duration(milliseconds: 6000),
              child: child.children[1],
            ),
          ),
        ],
      );
    } else {
      return MarqueeWidget(
        curve: Curves.linear,
        outCurve: Curves.linear,
        animationDuration: (child.runtimeType == Text)
            ? Duration(
                milliseconds: (3000 +
                        clampDouble((child as Text).data!.length * 100 - 3000,
                            0, 15000))
                    .round())
            : const Duration(milliseconds: 6000),
        child: originalChild,
      );
    }
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

  @override
  Widget build(BuildContext context) {
    Substitution data = substitutionData;
    TextTheme textTheme = Theme.of(context).textTheme;

    List<Widget> notchChildren = [
      if (doesExist(data.klasse))
        Row(
          spacing: 8.0,
          children: [
            Icon(Icons.school_outlined),
            Text(
              data.klasse!,
              style: textTheme.titleMedium,
            ),
          ],
        ),
      if (doesExist(data.fach))
        Text(
          data.fach!,
          style: textTheme.titleMedium,
        ),
      if (doesExist(data.art))
        Text(
          data.art!,
          style: textTheme.titleMedium,
        ),
      if (doesExist(data.stunde))
        Text(
          data.stunde,
          style: textTheme.titleMedium,
        ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: DividedCard(
        spacing: 2.0,
        forceAlignment: true,
        noMarqueeChildren: [
          if (doesExist(data.hinweis))
            Row(
              spacing: 12.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                ),
                Flexible(child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    data.hinweis!,
                    style: textTheme.bodyMedium
                  ),
                ))
              ],
            ),
          if (doesExist(data.hinweis2))
            Row(
              spacing: 12.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                ),
                Flexible(child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                      data.hinweis2!,
                      style: textTheme.bodyMedium
                  ),
                ))
              ],
            ),
        ],
        children: [
          Row(
            children: (notchChildren.length > 3)
                ? notchChildren.sublist(0, 2)
                : notchChildren,
          ),
          if (notchChildren.length > 3)
            Row(
              children: notchChildren.sublist(2),
            ),
        ],
      ),
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
