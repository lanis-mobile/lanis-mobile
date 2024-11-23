import 'package:flutter/material.dart';
import 'package:sph_plan/shared/account_types.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/applet_parser.dart';
import '../core/sph/sph.dart';
import '../utils/logger.dart';

typedef RefreshFunction = Future<void> Function();
typedef UpdateSetting = Future<void> Function(String key, String value);
typedef BuilderFunction<T> = Widget Function(BuildContext, T, AccountType, Map<String, String?>, UpdateSetting, RefreshFunction? refresh);

class CombinedAppletBuilder<T> extends StatefulWidget {
  final AppletParser<T> parser;
  final String phpUrl;
  final Map<String, String?> settingsDefaults;
  final AccountType accountType;
  final BuilderFunction<T> builder;
  const CombinedAppletBuilder({super.key, required this.parser, required this.phpUrl, required this.settingsDefaults, required this.accountType, required this.builder,});

  @override
  State<CombinedAppletBuilder<T>> createState() => _CombinedAppletBuilderState<T>();
}

class _CombinedAppletBuilderState<T> extends State<CombinedAppletBuilder<T>> {
  Widget _errorWidget() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error),
          Text(AppLocalizations.of(context)!.errorOccurred),
        ],
      ),
    );
  }

  Widget _loadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void initState() {
    widget.parser.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.parser.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data?.status == FetcherStatus.error) {
          return _errorWidget();
        } else if (!snapshot.hasData || snapshot.data?.status == FetcherStatus.fetching) {
          logger.i('At first loading state');
          return _loadingState();
        } else {
          logger.i('At builder');
          return StreamBuilder<Map<String, String?>>(
            stream: sph!.prefs.kv.subscribeAllApplet(widget.phpUrl, widget.settingsDefaults),
            builder: (context, dbSnapshot) {
              if (dbSnapshot.hasError) {
                return _errorWidget();
              } else if (!snapshot.hasData) {
                return _loadingState();
              }
              return widget.builder(
                context,
                snapshot.data!.content as T,
                widget.accountType,
                dbSnapshot.data ?? {},
                    (String key, String value) async {
                  await sph!.prefs.kv.set(key, value);
                },
                () async {
                  await widget.parser.fetchData(forceRefresh: true);
                },
              );
            },
          );
        }
      },
    );
  }
}
