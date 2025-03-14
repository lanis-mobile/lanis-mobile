import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/applets/abitur_helper/definition.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/models/abitur_helper.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';

class AbiturHelperView extends StatelessWidget {
  final Function? openDrawerCb;

  const AbiturHelperView({super.key, this.openDrawerCb});

  BorderRadius _getRadius(final int index, final int length) {
    if (length == 1) {
      return BorderRadius.circular(12.0);
    }

    if (index == 0) {
      return BorderRadius.vertical(top: Radius.circular(12.0));
    } else if (index == 1 && length == 2) {
      return BorderRadius.vertical(bottom: Radius.circular(12.0));
    } else {
      if (index == length - 1) {
        return BorderRadius.vertical(bottom: Radius.circular(12.0));
      }

      return BorderRadius.zero;
    }
  }


  @override
  Widget build(BuildContext context) {
    return CombinedAppletBuilder(
        parser: sph!.parser.abiturParser,
        phpUrl: abiturHelperDefinition.appletPhpUrl,
        settingsDefaults: abiturHelperDefinition.settingsDefaults,
        accountType: sph!.session.accountType,
        showErrorAppBar: true,
        loadingAppBar: AppBar(),
        builder:
            (context, data, accountType, settings, updateSetting, refresh) {
          final List<AbiturRow> writtenExams = data.where((element) => element.type == AbiturRowType.written).toList();
          final List<AbiturRow> oralExams = data.where((element) => element.type == AbiturRowType.oral).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Abitur Helper'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 16.0,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Schriftliche Prüfungen', style: Theme.of(context).textTheme.headlineSmall),
                          SizedBox(height: 8.0),
                          for (final (i, exam) in writtenExams.indexed) ...[
                            Card.filled(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: _getRadius(i, writtenExams.length),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runAlignment: WrapAlignment.spaceBetween,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      Text(exam.date?.format('HH:mm - dd.MM.yyyy') ?? ''),
                                      Text(exam.subject),
                                      Text(exam.room),
                                      Text(exam.inspector),
                                    ],
                                  )),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Mündliche Prüfungen', style: Theme.of(context).textTheme.headlineSmall),
                          SizedBox(height: 8.0),
                          for (final (i, exam) in oralExams.indexed) ...[
                            Card.filled(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: _getRadius(i, oralExams.length),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runAlignment: WrapAlignment.spaceBetween,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      Text(exam.date?.format('HH:mm - dd.MM.yyyy') ?? ''),
                                      Text(exam.subject),
                                      Text(exam.room),
                                      Text(exam.chair ?? ''),
                                      Text(exam.protocol ?? ''),
                                      Text(exam.inspector),
                                    ],
                                  )),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Noten', style: Theme.of(context).textTheme.headlineSmall),
                          SizedBox(height: 8.0),
                          for (final (i, exam) in data.indexed) ...[
                            Card.filled(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: _getRadius(i, oralExams.length),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runAlignment: WrapAlignment.spaceBetween,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      Text(exam.subject),
                                      Text(exam.grade),
                                      Text(exam.basePoints?.toString() ?? ''),
                                      Text(exam.multiplicationPoints?.toString() ?? ''),
                                    ],
                                  )),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                  
                  
                ],
              ),
            ),
          );
        });
  }
}
