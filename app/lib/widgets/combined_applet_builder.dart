import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/models/account_types.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/applet_parser.dart';
import '../core/sph/sph.dart';

typedef RefreshFunction = Future<void> Function();
typedef UpdateSetting = Future<void> Function(String key, String value);
typedef BuilderFunction<T> = Widget Function(BuildContext, T, AccountType,
    Map<String, String?>, UpdateSetting, RefreshFunction? refresh);

class CombinedAppletBuilder<T> extends StatefulWidget {
  final AppletParser<T> parser;
  final String phpUrl;
  final Map<String, String?> settingsDefaults;
  final AccountType accountType;
  final BuilderFunction<T> builder;
  const CombinedAppletBuilder({
    super.key,
    required this.parser,
    required this.phpUrl,
    required this.settingsDefaults,
    required this.accountType,
    required this.builder,
  });

  @override
  State<CombinedAppletBuilder<T>> createState() =>
      _CombinedAppletBuilderState<T>();
}

class _CombinedAppletBuilderState<T> extends State<CombinedAppletBuilder<T>> {
  late Map<String, String?> appletSettings;
  bool _loading = true;

  Widget _errorWidget(Function refresh) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error),
          Text(AppLocalizations.of(context)!.errorOccurred),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              refresh();
            },
            child: Text(AppLocalizations.of(context)!.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _loadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void initSettings() async {
    appletSettings = await sph!.prefs.kv
        .getAllApplet(widget.phpUrl, widget.settingsDefaults);
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
    return StreamBuilder(
      stream: widget.parser.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data?.status == FetcherStatus.error) {
          return _errorWidget(
              () => widget.parser.fetchData(forceRefresh: true));
        } else if (!snapshot.hasData ||
            snapshot.data?.status == FetcherStatus.fetching ||
            _loading) {
          return _loadingState();
        } else {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (snapshot.data?.contentStatus == ContentStatus.offline) Container(
                height: 32,
                color: Theme.of(context).secondaryHeaderColor.withOpacity(0.7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.offline_pin,
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.offline} (${snapshot.data?.fetchedAt.format('E dd.MM HH:mm')})',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: widget.builder(
                  context,
                  snapshot.data!.content as T,
                  widget.accountType,
                  appletSettings,
                      (String key, String value) async {
                    await sph!.prefs.kv.setAppletValue(widget.phpUrl, key, value);
                    setState(() {
                      appletSettings[key] = value;
                    });
                  },
                      () async {
                    await widget.parser.fetchData(forceRefresh: true);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
