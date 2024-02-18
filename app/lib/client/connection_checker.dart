import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final connectionChecker = InternetConnection.createInstance(
  customCheckOptions: [
    InternetCheckOption(
      uri: Uri.parse('https://start.schulportal.hessen.de/ajax_login.php'),
    ),
  ],
);