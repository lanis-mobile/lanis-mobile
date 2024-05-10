import 'package:flutter/material.dart';
import 'package:sph_plan/client/client_submodules/substitutions.dart';
import 'package:sph_plan/shared/widgets/marquee.dart';
import 'substitutions_listtile.dart';

class SubstitutionGridTile extends StatelessWidget {
  final Substitution substitutionData;
  const SubstitutionGridTile({super.key, required this.substitutionData});

  bool doesNoticeExist(String? info) {
    return (info == null || info.trim() == "" || info == "---");
  }

  Widget? substitutionInfoWithIcon(
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
          SubstitutionsFormattedText(value!, Theme.of(context).textTheme.bodyMedium!)
      ]));
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: (substitutionData.art != null)
                ? MarqueeWidget(
                    child: Text(
                    substitutionData.art!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ))
                : null,
          ),
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
                substitutionInfoWithIcon(context, "Vertreter",
                        substitutionData.vertreter, Icons.person) ??
                    const SizedBox.shrink(),
                substitutionInfoWithIcon(context, "Lehrer",
                        substitutionData.lehrer, Icons.school) ??
                    const SizedBox.shrink(),
                substitutionInfoWithIcon(
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
                          child: MarqueeWidget(
                            direction: Axis.horizontal,
                            animationDuration: Duration(
                                milliseconds:
                                    substitutionData.hinweis!.length * 130),
                            child: Text(
                              substitutionData.hinweis!,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 4)
                ],
              ),
            )
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (!doesNoticeExist(substitutionData.klasse)) ...[
                SizedBox(
                  width: 230,
                  child: MarqueeWidget(
                    child: Text(
                      substitutionData.klasse!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                )
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
    ));
  }
}
