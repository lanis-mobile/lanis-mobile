import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubstitutionWidget extends StatelessWidget {
  final Map<String, dynamic> substitutionData;
  const SubstitutionWidget({super.key, required this.substitutionData});

  // TODO VP REWORK ("revert")
  // REWORK THIS SHIT SO IT DOESN'T USE CONFUSING IF STATEMENTS
  // ALSO PUT HINWEIS IN THE SAME LINE AGAIN

  bool doesNoticeExist(String? info) {
    return (info == null || info == "" || info == "---");
  }

  Widget? getSubstitutionInfo(BuildContext context, String key, String? value, IconData icon) {
    if (doesNoticeExist(value)) {
      return null;
    }

    return Padding(
        padding: const EdgeInsets.only(right: 30, left: 30, bottom: 2),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(icon),
              ),
              Text(
                key,
                style: Theme.of(context).textTheme.labelLarge,
              )
            ],
          ),
          Text(value!)
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: (doesNoticeExist(substitutionData["Vertreter"]) &&
          doesNoticeExist(substitutionData["Lehrer"]) &&
          doesNoticeExist(substitutionData["Raum"]) &&
          doesNoticeExist(substitutionData["Fach"]) &&
          doesNoticeExist(substitutionData["Hinweis"])),
      title: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (substitutionData['Art'] != null) ...[
              Text(
                substitutionData['Art'],
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
            Flexible(
                child: Text(substitutionData["Klasse"] ?? "Keine Klasse angegeben",
                    style: (substitutionData['Art'] != null)
                        ? null
                        : Theme.of(context)
                        .textTheme
                        .titleLarge) // highlight "Klasse" when there is no "Art" information
            ),
            Text(
              substitutionData['Stunde'] ?? "",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 0,
                    bottom: (doesNoticeExist(substitutionData["Vertreter"]) &&
                        doesNoticeExist(substitutionData["Lehrer"]) &&
                        doesNoticeExist(substitutionData["Raum"]) &&
                        !doesNoticeExist(substitutionData["Fach"]))
                        ? 12
                        : 0),
                child: Column(
                  children: [
                    getSubstitutionInfo(context,"Vertreter", substitutionData["Vertreter"],
                        Icons.person) ??
                        const SizedBox.shrink(),
                    getSubstitutionInfo(context,
                        "Lehrer", substitutionData["Lehrer"], Icons.school) ??
                        const SizedBox.shrink(),
                    getSubstitutionInfo(context,
                        "Raum", substitutionData["Raum"], Icons.room) ??
                        const SizedBox.shrink(),
                  ],
                ),
              ),
              if (!doesNoticeExist(substitutionData["Hinweis"])) ...[
                Padding(
                  padding: EdgeInsets.only(
                      right: 30,
                      left: 30,
                      top: 2,
                      bottom: doesNoticeExist(substitutionData["Fach"]) ? 12 : 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.info),
                          ),
                          Text(
                            "Hinweis",
                            style: Theme.of(context).textTheme.labelLarge,
                          )
                        ],
                      ),
                      Text(
                          "${toBeginningOfSentenceCase(substitutionData["Hinweis"])}")
                    ],
                  ),
                )
              ]
            ],
          ),
          if (!doesNoticeExist(substitutionData["Fach"])) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  substitutionData["Fach"],
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}
