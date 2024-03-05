import 'package:flutter/material.dart';

import '../../shared/marquee.dart';

class SubstitutionWidget extends StatelessWidget {
  final Map<String, dynamic> substitutionData;
  const SubstitutionWidget({super.key, required this.substitutionData});

  bool doesNoticeExist(String? info) {
    return (info == null || info == "" || info == "---");
  }

  Widget? getSubstitutionInfo(
      BuildContext context, String key, String? value, IconData icon) {
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
        child: (substitutionData['Art'] != null)
            ? MarqueeWidget(
                direction: Axis.horizontal,
                child: Text(
                  substitutionData['Art'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )
            : null,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                getSubstitutionInfo(context, "Vertreter",
                        substitutionData["Vertreter"], Icons.person) ??
                    const SizedBox.shrink(),
                getSubstitutionInfo(context, "Lehrer",
                        substitutionData["Lehrer"], Icons.school) ??
                    const SizedBox.shrink(),
                getSubstitutionInfo(context, "Raum", substitutionData["Raum"],
                        Icons.room) ??
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
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          substitutionData["Hinweis"],
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4)
                ],
              ),
            )
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!doesNoticeExist(substitutionData["Klasse"])) ...[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: MarqueeWidget(
                      child: Text(
                    substitutionData["Klasse"],
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
                ),
              ],
              if (!doesNoticeExist(substitutionData["Fach"])) ...[
                Text(
                  substitutionData["Fach"],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
              if (!doesNoticeExist(substitutionData['Stunde'])) ...[
                Text(
                  substitutionData['Stunde'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
