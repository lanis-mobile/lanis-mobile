import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sph_plan/utils/file_operations.dart';
import 'package:sph_plan/view/settings/settings.dart';
import 'package:sph_plan/view/settings/settings_page_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/sph/sph.dart';

class CalendarExport extends SettingsColours {
  const CalendarExport({super.key});

  @override
  State<CalendarExport> createState() => _CalendarExportState();
}

class _CalendarExportState extends SettingsColoursState<CalendarExport> {
  @override
  Widget build(BuildContext context) {
    return SettingsPage(
        backgroundColor: backgroundColor,
        title: Text(AppLocalizations.of(context)!.calendarExport),
        children: [
          FutureBuilder(
            future: sph!.parser.calendarParser.getExports(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return LinearProgressIndicator();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.calendarExportHint,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    SettingsTileWidget(
                        tile: SettingsTile(
                          title: (context) => "PDF",
                          subtitle: (context) async => AppLocalizations.of(context)!.dayWeekYearsList,
                          icon: Icons.picture_as_pdf,
                          screen: (context) async => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CalendarExportPdf(years: snapshot.data!.years.toList(),)),
                          ),
                        ),
                        disableSetState: true,
                        foregroundColor: foregroundColor,
                        index: 0,
                        length: 3
                    ),
                    SettingsTileWidget(
                        tile: SettingsTile(
                          title: (context) => "iCal / ICS",
                          subtitle: (context) async => AppLocalizations.of(context)!.updatesYearsImportableList,
                          icon: Icons.date_range,
                          screen: (context) async => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CalendarExportICal(years: snapshot.data!.years.toList(), subscriptionLink: snapshot.data!.subscriptionLink,)),
                          ),
                        ),
                        disableSetState: true,
                        foregroundColor: foregroundColor,
                        index: 1,
                        length: 3
                    ),
                    SettingsTileWidget(
                        tile: SettingsTile(
                          title: (context) => "CSV",
                          subtitle: (context) async => AppLocalizations.of(context)!.yearsImportableList,
                          icon: Icons.description,
                          screen: (context) async => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CalendarExportCsv(years: snapshot.data!.years.toList(),)),
                          ),
                        ),
                        disableSetState: true,
                        foregroundColor: foregroundColor,
                        index: 2,
                        length: 3
                    ),
                  ],
                ),
              );
            },
          )
        ]
    );
  }
}

class CalendarExportPdf extends SettingsColours {
  final List<int> years;
  const CalendarExportPdf({super.key, required this.years});

  @override
  State<CalendarExportPdf> createState() => _CalendarExportPdfState();
}

class _CalendarExportPdfState extends SettingsColoursState<CalendarExportPdf> {
  ({String type, String link})? selected;

  void onChanged(({String type, String link})? value) {
    setState(() {
      selected = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: Text(AppLocalizations.of(context)!.pdfExport),
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: selected != null ? () async {
          showFileModal(context, FileInfo(
            name: "${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}-${selected!.type}-${AppLocalizations.of(context)!.calendar.toLowerCase()}.pdf",
            url: Uri.parse(selected!.link),
          ));
        } : null,
        foregroundColor: selected == null ? Theme.of(context).colorScheme.onSurfaceVariant : null,
        backgroundColor: selected == null ? Theme.of(context).colorScheme.surfaceContainerHighest : null,
        child: Icon(Icons.download),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.day,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              RadioListTile(
                  value: (type: AppLocalizations.of(context)!.today.toLowerCase(), link: "https://start.schulportal.hessen.de/kalender.php?a=export&export=pdf&day=1"),
                  groupValue: selected,
                  onChanged: onChanged,
                  title: Text(AppLocalizations.of(context)!.today),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile(
                  value: (type: AppLocalizations.of(context)!.tomorrow.toLowerCase(), link: "https://start.schulportal.hessen.de/kalender.php?a=export&export=pdf&day=2"),
                  groupValue: selected,
                  onChanged: onChanged,
                  title: Text(AppLocalizations.of(context)!.tomorrow),
                contentPadding: EdgeInsets.zero,
              ),
              SizedBox(
                height: 24.0,
              ),
              Text(
                AppLocalizations.of(context)!.week,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              RadioListTile(
                value: (type: AppLocalizations.of(context)!.currentWeek.toLowerCase().replaceAll(" ", "-"), link: "https://start.schulportal.hessen.de/kalender.php?a=export&export=pdf&week=1"),
                groupValue: selected,
                onChanged: onChanged,
                title: Text(AppLocalizations.of(context)!.currentWeek),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile(
                value: (type: AppLocalizations.of(context)!.nextWeek.toLowerCase().replaceAll(" ", "-"), link: "https://start.schulportal.hessen.de/kalender.php?a=export&export=pdf&week=2"),
                groupValue: selected,
                onChanged: onChanged,
                title: Text(AppLocalizations.of(context)!.nextWeek),
                contentPadding: EdgeInsets.zero,
              ),
              for (int year in widget.years) ...[
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  "$year / ${year + 1}",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                RadioListTile(
                  value: (type: "${AppLocalizations.of(context)!.short}-$year", link: "https://start.schulportal.hessen.de/kalender.php?a=export&export=pdf&year=$year"),
                  groupValue: selected,
                  onChanged: onChanged,
                  title: Text(AppLocalizations.of(context)!.shortenedCalendar),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile(
                  value: (type: "${AppLocalizations.of(context)!.extended}-$year", link: "https://start.schulportal.hessen.de/kalender.php?a=export&export=pdf-extended&year=$year"),
                  groupValue: selected,
                  onChanged: onChanged,
                  title: Text(AppLocalizations.of(context)!.extendedCalendar),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile(
                  value: (type: "${AppLocalizations.of(context)!.wall}-$year", link: "https://start.schulportal.hessen.de/kalender.php?a=export&export=wandkalender&year=$year"),
                  groupValue: selected,
                  onChanged: onChanged,
                  title: Text(AppLocalizations.of(context)!.wallCalendar),
                  contentPadding: EdgeInsets.zero,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class CalendarExportCsv extends SettingsColours {
  final List<int> years;
  const CalendarExportCsv({super.key, required this.years});

  @override
  State<CalendarExportCsv> createState() => _CalendarExportCsvState();
}

class _CalendarExportCsvState extends SettingsColoursState<CalendarExportCsv> {
  ({String type, String link})? selected;

  void onChanged(({String type, String link})? value) {
    setState(() {
      selected = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: Text(AppLocalizations.of(context)!.csvExport),
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: selected != null ? () async {
          showFileModal(context, FileInfo(
            name: "${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}-${selected!.type}-${AppLocalizations.of(context)!.calendar.toLowerCase()}.csv",
            url: Uri.parse(selected!.link),
          ));
        } : null,
        foregroundColor: selected == null ? Theme.of(context).colorScheme.onSurfaceVariant : null,
        backgroundColor: selected == null ? Theme.of(context).colorScheme.surfaceContainerHighest : null,
        child: Icon(Icons.download),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.years,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              for (int year in widget.years) ...[
                RadioListTile(
                  value: (type: "$year", link: "https://start.schulportal.hessen.de/kalender.php?a=export&export=csv&year=$year"),
                  groupValue: selected,
                  onChanged: onChanged,
                  title: Text("$year / ${year + 1}"),
                  contentPadding: EdgeInsets.zero,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class CalendarExportICal extends SettingsColours {
  final List<int> years;
  final String subscriptionLink;
  const CalendarExportICal({super.key, required this.years, required this.subscriptionLink});

  @override
  State<CalendarExportICal> createState() => _CalendarExportICalState();
}

class _CalendarExportICalState extends SettingsColoursState<CalendarExportICal> {
  ({String type, String link})? selected;

  void onChanged(({String type, String link})? value) {
    setState(() {
      selected = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: Text(AppLocalizations.of(context)!.iCalICSExport),
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: selected != null ? () async {
          showFileModal(context, FileInfo(
            name: "${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}-${selected!.type}-${AppLocalizations.of(context)!.calendar.toLowerCase()}.ics",
            url: Uri.parse(selected!.link),
          ));
        } : null,
        foregroundColor: selected == null ? Theme.of(context).colorScheme.onSurfaceVariant : null,
        backgroundColor: selected == null ? Theme.of(context).colorScheme.surfaceContainerHighest : null,
        child: Icon(Icons.download),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: foregroundColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.subscription,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.subscriptionHint,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      SizedBox(
                        height: 36.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            Material(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12.0),
                              child: InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: widget.subscriptionLink));
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(AppLocalizations.of(context)!.linkCopied),
                                  ));
                                },
                                borderRadius: BorderRadius.circular(12.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                          Icons.copy,
                                        size: 18.0,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                      SizedBox(width: 4.0,),
                                      Text(
                                        widget.subscriptionLink,
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Theme.of(context).colorScheme.onPrimaryContainer
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ),
                            )
                          ],
                        )
                      )
                    ],
                  ),
                )
              ),
              SizedBox(
                height: 24.0,
              ),
              Text(
                AppLocalizations.of(context)!.years,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              for (int year in widget.years) ...[
                RadioListTile(
                  value: (type: "$year", link: "https://start.schulportal.hessen.de/kalender.php?a=export&export=ical&year=$year"),
                  groupValue: selected,
                  onChanged: onChanged,
                  title: Text("$year / ${year + 1}"),
                  contentPadding: EdgeInsets.zero,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}
