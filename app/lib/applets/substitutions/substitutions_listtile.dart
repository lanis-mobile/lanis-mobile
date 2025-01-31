import 'package:flutter/material.dart';

import '../../models/substitution.dart';

class SubstitutionRow extends StatelessWidget {
  final List<Widget> children;
  final bool isFirst;
  final bool isLast;

  const SubstitutionRow(
      {super.key,
      required this.children,
      this.isFirst = false,
      this.isLast = false});

  BorderRadius getRadius(int index) {
    if (index == 0 && children.length > 1) {
      return BorderRadius.only(
          topLeft: isFirst ? Radius.circular(12.0) : Radius.zero,
          topRight: isLast ? Radius.circular(12.0) : Radius.zero);
    } else if (index == 0) {
      return BorderRadius.circular(12.0);
    } else if (index == children.length - 1) {
      return BorderRadius.only(
        topRight: isFirst ? Radius.circular(12.0) : Radius.zero,
      );
    } else {
      return BorderRadius.zero;
    }
  }

  Alignment getAlignment(int index) {
    if (index == 0) {
      return Alignment.centerLeft;
    } else if (index == children.length - 1) {
      return Alignment.centerRight;
    } else {
      return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 2.0,
      children: List.generate(children.length, (index) {
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: getRadius(index),
              color: Colors.red,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: children[index],
            ),
          ),
        );
      }),
    );
  }
}

class AndroidDesign extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final EdgeInsets padding;

  const AndroidDesign(
      {super.key,
      required this.children,
      this.spacing = 2.0,
      this.padding = const EdgeInsets.all(12.0)});

  BorderRadius getVerticalRadius(int index) {
    int length = children.length;
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
          bottomLeft: colIndex == children.length - 1
              ? Radius.circular(12.0)
              : Radius.zero);
    } else if (rowIndex == 0) {
      return BorderRadius.circular(12.0);
    } else if (rowIndex == length - 1) {
      return BorderRadius.only(
        topRight: colIndex == 0 ? Radius.circular(12.0) : Radius.zero,
        bottomRight: colIndex == children.length - 1
            ? Radius.circular(12.0)
            : Radius.zero,
      );
    } else {
      return BorderRadius.zero;
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
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: padding,
                    child: row.children[rowIndex],
                  ),
                ),
              );
            }),
          );
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: getVerticalRadius(index),
            color: Colors.red,
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        );
      }),
    );
  }
}

class SubstitutionListTile extends StatelessWidget {
  final Substitution substitutionData;
  const SubstitutionListTile({super.key, required this.substitutionData});

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
        SizedBox(
          child: Row(
            spacing: 8.0,
            children: [
              Icon(Icons.school_outlined),
              Text(
                data.klasse!,
                style: textTheme.titleMedium,
              ),
            ],
          ),
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
      padding: const EdgeInsets.all(8.0),
      child: AndroidDesign(
        spacing: 2.0,
        padding: const EdgeInsets.all(8.0),
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
          Text('Lol'),
          Text('Serh langer Text zum testen. Serh langer Text zum testen'),
        ],
      ),
    );
  }

  /*
   @override
  Widget build(BuildContext context) {
    Substitution data = substitutionData;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        child: Column(
          spacing: 8.0,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 8.0,
                  children: [
                    if (doesExist(data.klasse))
                      Text(
                        data.klasse!,
                        style: textTheme.titleMedium,
                      ),
                    if (doesExist(data.klasse_alt) && !doesExist(data.klasse))
                      Text(
                        data.klasse_alt!,
                        style: textTheme.titleMedium,
                      ),
                    if (doesExist(data.lerngruppe)) Text('(${data.lerngruppe})')
                  ],
                ),
                if (doesExist(data.fach))
                  Text(
                    data.fach!,
                    style: textTheme.titleMedium,
                  ),
              ],
            ),
            Row(
              spacing: 8.0,
              children: [
                if (doesExistList([data.lehrer, data.vertreter]))
                  Icon(Icons.school_outlined),
                // Für Vertreter
                if (doesExistList([data.vertreter, data.Vertreterkuerzel]))
                  Text(
                    [
                      if (doesExist(data.vertreter)) data.vertreter!,
                      if (!doesExist(data.vertreter) &&
                          doesExist(data.Vertreterkuerzel))
                        data.Vertreterkuerzel!,
                      if (doesExist(data.vertreter) &&
                          doesExist(data.Vertreterkuerzel))
                        "(${data.Vertreterkuerzel})"
                    ].join(" "),
                    style: textTheme.bodyLarge,
                  ),
                if ((doesExist(data.lehrer) || doesExist(data.Lehrerkuerzel)) &&
                    (doesExist(data.vertreter) ||
                        doesExist(data.Vertreterkuerzel)))
                  Text("->"),
                if (doesExist(data.lehrer) || doesExist(data.Lehrerkuerzel))
                  Text(
                    [
                      if (doesExist(data.lehrer)) data.lehrer!,
                      if (!doesExist(data.lehrer) &&
                          doesExist(data.Lehrerkuerzel))
                        data.Lehrerkuerzel!,
                      if (doesExist(data.lehrer) &&
                          doesExist(data.Lehrerkuerzel))
                        "(${data.Lehrerkuerzel})"
                    ].join(" "),
                    style: textTheme.bodyLarge!.copyWith(
                      decoration: (doesExist(data.vertreter) &&
                              doesExist(data.Vertreterkuerzel))
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
              ],
            ),
            Row(
              spacing: 8.0,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 8.0,
                  children: [
                    if (doesExist(data.raum)) Icon(Icons.room_outlined),
                    if (doesExist(data.raum))
                      Text(
                        data.raum!,
                        style: textTheme.bodyLarge,
                      ),
                  ],
                ),
                if (doesExist(data.stunde))
                  Text(data.stunde,
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              ],
            ),
            if (doesExistList([data.hinweis, data.hinweis2]))
              Divider(
                height: 4.0,
              ),
            Row(
              spacing: 12.0,
              children: [
                if (doesExist(data.hinweis))
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20.0,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                if (doesExist(data.hinweis))
                  SubstitutionsFormattedText(
                    data.hinweis!,
                    Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
              ],
            ),
            Row(
              spacing: 12.0,
              children: [
                if (doesExist(data.hinweis2))
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20.0,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                if (doesExist(data.hinweis2))
                  SubstitutionsFormattedText(
                    data.hinweis2!,
                    Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  } */
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
