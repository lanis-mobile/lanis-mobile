import 'package:intl/intl.dart';

import '../../background_service.dart';
import '../../core/sph/sph.dart';
import '../../models/account_types.dart';
import '../../models/substitution.dart';

Future<void> substitutionsBackgroundTask(SPH sph, AccountType accountType, BackgroundTaskToolkit tools) async {
  final vPlan = await sph.parser.substitutionsParser.getHome();
  List<Substitution> allSubstitutions = vPlan.allSubstitutions;
  String messageBody = "";

  for (final entry in allSubstitutions) {
    final time =
        "${weekDayGer(entry.tag)} ${entry.stunde.replaceAll(" - ", "/")}";
    final type = entry.art ?? "";
    final subject = entry.fach ?? "";
    final teacher = entry.lehrer ?? "";
    final classInfo = entry.klasse ?? "";

    final entryText = [time, type, subject, teacher, classInfo]
        .where((e) => e.isNotEmpty)
        .join(" - ");

    messageBody += "$entryText\n";
  }
  tools.sendMessage('${allSubstitutions.length}', messageBody);
}

String weekDayGer(String dateString) {
  final inputFormat = DateFormat('dd.MM.yyyy');
  final dateTime = inputFormat.parse(dateString);

  final germanFormat = DateFormat('E', 'de');
  return germanFormat.format(dateTime);
}
