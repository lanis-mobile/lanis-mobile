import 'package:flutter/material.dart';

/// A global controller to manage AppBar actions.
class AppBarController extends ChangeNotifier {
  AppBarController._();
  static final AppBarController instance = AppBarController._();

  final Map<String, Widget> _actions = {};
  final Map<
      String,
      ({
        Widget widget,
        int weight,
        bool Function(BoxConstraints)? canBeUsed
      })> _leadingActions = {};
  String? overrideTitle;
  String? secondTitle;
  Color? overrideColor;

  List<Widget> get actions => List.unmodifiable(_actions.values);

  Widget? getLeadingAction(BoxConstraints constraints) {
    if (_leadingActions.isEmpty) return null;

    // Filter actions that can be used in the current constraints
    var availableActions = _leadingActions.values.where((action) {
      return action.canBeUsed?.call(constraints) ?? true;
    });

    if (availableActions.isEmpty) return null;

    // Find the leading action with the highest weight among available actions
    var highest = availableActions.reduce(
        (current, next) => next.weight > current.weight ? next : current);
    return highest.widget;
  }

  void addAction(String id, Widget action) {
    _actions[id] = action;
    notifyListeners();
  }

  void setLeadingAction(String id, Widget widget,
      {int weight = 0, bool Function(BoxConstraints)? canBeUsed}) {
    _leadingActions[id] =
        (widget: widget, weight: weight, canBeUsed: canBeUsed);
    notifyListeners();
  }

  void removeLeadingAction(String id) {
    if (_leadingActions.remove(id) != null) {
      notifyListeners();
    }
  }

  void removeAction(String id) {
    if (_actions.remove(id) != null) {
      notifyListeners();
    }
  }

  void setOverrideTitle(String? title) {
    overrideTitle = title;
    notifyListeners();
  }

  void setSecondTitle(String? title) {
    secondTitle = title;
    notifyListeners();
  }

  Color setOverrideColor(Color? color) {
    overrideColor = color;
    notifyListeners();
    return overrideColor ?? Colors.transparent;
  }

  void clear() {
    _actions.clear();
    _leadingActions.clear();
    overrideTitle = null;
    secondTitle = null;
    overrideColor = null;
    notifyListeners();
  }
}

class DynamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;
  const DynamicAppBar(
      {super.key,
      required this.title,
      required this.automaticallyImplyLeading});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppBarController.instance,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            String displayTitle =
                AppBarController.instance.overrideTitle ?? title;
            if (AppBarController.instance.secondTitle != null) {
              displayTitle =
                  '$displayTitle - ${AppBarController.instance.secondTitle}';
            }

            final leadingAction =
                AppBarController.instance.getLeadingAction(constraints);

            return AppBar(
              scrolledUnderElevation: 0,
              title: Text(displayTitle),
              automaticallyImplyLeading:
                  automaticallyImplyLeading && leadingAction == null,
              leading: leadingAction,
              backgroundColor:
                  AppBarController.instance.overrideColor ?? Colors.transparent,
              actions: AppBarController.instance.actions,
            );
          },
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
