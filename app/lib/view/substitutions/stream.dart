import 'package:flutter/material.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:sph_plan/view/substitutions/view.dart';

import '../../client/client.dart';

/// The [StaticSubstitutionsView] utilizing the [SubstitutionsFetcher] to display the substitutions.
class SubstitutionsView extends StatefulWidget {
  const SubstitutionsView({super.key});

  @override
  State<StatefulWidget> createState() => _SubstitutionsViewState();
}

class _SubstitutionsViewState extends State<SubstitutionsView>
    with TickerProviderStateMixin {
  final SubstitutionsFetcher substitutionsFetcher =
      client.fetchers.substitutionsFetcher;

  @override
  void initState() {
    super.initState();
    substitutionsFetcher.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FetcherResponse>(
      stream: substitutionsFetcher.stream,
      builder: (context, snapshot) {
        if (snapshot.data?.status == FetcherStatus.error) {
          return StaticSubstitutionsView(
            lanisException: snapshot.data?.error,
            fetcher: substitutionsFetcher,
            refresh: () => substitutionsFetcher.fetchData(forceRefresh: true),
            loading: false,
          );
        }  else {
          return StaticSubstitutionsView(
            plan: snapshot.data?.content,
            fetcher: substitutionsFetcher,
            refresh: () => substitutionsFetcher.fetchData(forceRefresh: true),
            loading: snapshot.data?.status == FetcherStatus.fetching ||
                snapshot.data == null,
          );
        }
      },
    );
  }
}
