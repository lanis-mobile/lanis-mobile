import 'package:flutter/material.dart';
import 'package:sph_plan/utils/large_appbar.dart';

abstract class SettingsColours extends StatefulWidget {
  const SettingsColours({super.key});
}

abstract class SettingsColoursState<T extends SettingsColours>
    extends State<T> {
  Color foregroundColor = Colors.transparent;
  Color backgroundColor = Colors.transparent;
  Color sliderColor = Colors.transparent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (Theme.of(context).brightness == Brightness.light) {
      foregroundColor = Theme.of(context).colorScheme.surfaceContainerLow;
      backgroundColor = Theme.of(context).colorScheme.surfaceContainerHigh;
      sliderColor = Theme.of(context).colorScheme.surfaceDim;
    } else {
      foregroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      backgroundColor = Theme.of(context).colorScheme.surfaceContainer;
      sliderColor = Theme.of(context).colorScheme.surfaceBright;
    }
  }
}

class SettingsPage extends StatelessWidget {
  final Color backgroundColor;
  final Text title;
  final List<Widget> children;
  final EdgeInsets contentPadding;
  final void Function()? back;

  const SettingsPage({
    super.key,
    required this.backgroundColor,
    required this.title,
    this.contentPadding = EdgeInsets.zero,
    this.back,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: LargeAppBar(
        title: title,
        backgroundColor: backgroundColor,
        back: back,
      ),
      body: Padding(
        padding: contentPadding,
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}

class SettingsPageWithRefreshIndicator extends StatelessWidget {
  final Color backgroundColor;
  final Text title;
  final List<Widget> children;
  final EdgeInsets contentPadding;
  final Future<void> Function() onRefresh;
  final void Function()? back;

  const SettingsPageWithRefreshIndicator(
      {super.key,
      required this.backgroundColor,
      required this.title,
      this.contentPadding = EdgeInsets.zero,
      this.back,
      required this.onRefresh,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: LargeAppBar(
        title: title,
        backgroundColor: backgroundColor,
        back: back,
      ),
      body: Padding(
        padding: contentPadding,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: children,
          ),
        ),
      ),
    );
  }
}

typedef SettingsListBuilder = List<Widget> Function(
    BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot);

class SettingsPageWithStreamBuilder extends StatelessWidget {
  final Color backgroundColor;
  final Text title;
  final SettingsListBuilder builder;
  final EdgeInsets contentPadding;
  final void Function()? back;
  final Stream<Map<String, dynamic>> subscription;

  const SettingsPageWithStreamBuilder(
    {super.key,
    required this.backgroundColor,
    required this.title,
    this.contentPadding = EdgeInsets.zero,
    this.back,
    required this.subscription,
    required this.builder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: LargeAppBar(
        title: title,
        backgroundColor: backgroundColor,
        back: back,
      ),
      body: Padding(
        padding: contentPadding,
        child: StreamBuilder(
          stream: subscription,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            }

            return ListView(
              children: builder(context, snapshot),
            );
          },
        ),
      ),
    );
  }
}
