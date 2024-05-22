import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../client/fetcher.dart';
import '../exceptions/client_status_exceptions.dart';

class ErrorView extends StatelessWidget {
  late final LanisException data;
  late final Fetcher? fetcher;
  late final String name;
  ErrorView(
      {super.key,
      required this.data,
      required this.name,
      required this.fetcher});
  ErrorView.fromCode(
      {super.key,
      required int data,
      required this.name,
      required this.fetcher}) {
    this.data = LanisException.fromCode(data);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning,
                size: 40,
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    "Es gab wohl ein Problem, bitte sende uns einen Fehlerbericht!",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Text("Problem: ${data.cause}"),
              if (fetcher != null) Padding(
                padding: const EdgeInsets.only(top: 20),
                child: OutlinedButton(
                    onPressed: () async {
                      fetcher!.fetchData(forceRefresh: true);
                    },
                    child: Text(AppLocalizations.of(context)!.tryAgain)
                )
              ),
            ],
          ),
        )
      ],
    );
  }
}
