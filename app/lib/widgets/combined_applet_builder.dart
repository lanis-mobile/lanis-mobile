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
  late Map<String, String?> appletSettings;
  bool _loading = true;

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

  void initSettings () async {
    appletSettings = await sph!.prefs.kv.getAllApplet(widget.phpUrl, widget.settingsDefaults);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    widget.parser.fetchData();
    super.initState();
    initSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _loadingState();
    }
    return StreamBuilder(
      stream: widget.parser.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data?.status == FetcherStatus.error) {
          return _errorWidget();
        } else if (!snapshot.hasData || snapshot.data?.status == FetcherStatus.fetching) {
          return _loadingState();
        } else {
          return widget.builder(
            context,
            snapshot.data!.content as T,
            widget.accountType,
            appletSettings,
            (String key, String value) async {
              await sph!.prefs.kv.set(key, value);
            },
            () async {
              await widget.parser.fetchData(forceRefresh: true);
            },
          );
        }
      },
    );
  }
}
