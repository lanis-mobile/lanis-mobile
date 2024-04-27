import 'package:flutter/material.dart';
import 'package:sph_plan/client/client_submodules/substitutions.dart';

import '../marquee.dart';

class SubstitutionListTile extends StatelessWidget {
  final Substitution substitutionData;
  const SubstitutionListTile({super.key, required this.substitutionData});

  bool doesNoticeExist(String? info) {
    List empty = [null, "", " ", "-", "---"];
    return empty.contains(info);
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
      dense: (doesNoticeExist(substitutionData.vertreter) &&
          doesNoticeExist(substitutionData.lehrer) &&
          doesNoticeExist(substitutionData.raum) &&
          doesNoticeExist(substitutionData.fach) &&
          doesNoticeExist(substitutionData.hinweis)),
      title: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: (substitutionData.art != null)
            ? MarqueeWidget(
                direction: Axis.horizontal,
                child: Text(
                  substitutionData.art!,
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
                bottom: (doesNoticeExist(substitutionData.vertreter) &&
                        doesNoticeExist(substitutionData.lehrer) &&
                        doesNoticeExist(substitutionData.raum) &&
                        !doesNoticeExist(substitutionData.fach))
                    ? 12
                    : 0),
            child: Column(
              children: [
                getSubstitutionInfo(context, "Vertreter",
                        substitutionData.vertreter, Icons.person) ??
                    const SizedBox.shrink(),
                getSubstitutionInfo(context, "Lehrer", substitutionData.lehrer,
                        Icons.school) ??
                    const SizedBox.shrink(),
                getSubstitutionInfo(
                        context, "Raum", substitutionData.raum, Icons.room) ??
                    const SizedBox.shrink(),
              ],
            ),
          ),
          if (!doesNoticeExist(substitutionData.hinweis)) ...[
            Padding(
              padding: EdgeInsets.only(
                  right: 30,
                  left: 30,
                  top: 2,
                  bottom: doesNoticeExist(substitutionData.fach) ? 12 : 0),
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
                          substitutionData.hinweis!,
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
              if (!doesNoticeExist(substitutionData.klasse)) ...[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: MarqueeWidget(
                      child: Text(
                    substitutionData.klasse!,
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
                ),
              ],
              if (!doesNoticeExist(substitutionData.fach)) ...[
                Text(
                  substitutionData.fach!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
              if (!doesNoticeExist(substitutionData.stunde)) ...[
                Text(
                  substitutionData.stunde,
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
