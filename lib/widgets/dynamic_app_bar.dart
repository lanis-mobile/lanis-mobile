import 'package:flutter/material.dart';

/// A global controller to manage AppBar actions.
class AppBarController extends ChangeNotifier {
  AppBarController._();
  static final AppBarController instance = AppBarController._();

  final Map<String, Widget> _actions = {};
  String? overrideTitle;
  String? secondTitle; // Added secondTitle field
  Color? overrideColor;
  Widget? _leadingAction;
  bool _isClearing = false;

  List<Widget> get actions => List.unmodifiable(_actions.values);
  Widget? get leadingAction => _leadingAction;

  void add(String id, Widget action) {
    if (_isClearing) {
      // If we're in the middle of clearing, schedule this addition for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isClearing) {
          _actions[id] = action;
          notifyListeners();
        }
      });
      return;
    }
    _actions[id] = action;
    notifyListeners();
  }

  void setLeadingAction(Widget? widget) {
    if (_isClearing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isClearing) {
          _leadingAction = widget;
          notifyListeners();
        }
      });
      return;
    }
    _leadingAction = widget;
    notifyListeners();
  }

  void remove(String id) {
    if (_actions.remove(id) != null) {
      notifyListeners();
    }
  }

  void setOverrideTitle(String? title) {
    if (_isClearing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isClearing) {
          overrideTitle = title;
          notifyListeners();
        }
      });
      return;
    }
    overrideTitle = title;
    notifyListeners();
  }

  // Add method to set secondTitle
  void setSecondTitle(String? title) {
    if (_isClearing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isClearing) {
          secondTitle = title;
          notifyListeners();
        }
      });
      return;
    }
    secondTitle = title;
    notifyListeners();
  }

  Color setOverrideColor(Color? color) {
    if (_isClearing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isClearing) {
          overrideColor = color;
          notifyListeners();
        }
      });
      return overrideColor ?? Colors.transparent;
    }
    overrideColor = color;
    notifyListeners();
    return overrideColor ?? Colors.transparent;
  }

  void clear() {
    _isClearing = true;
    _actions.clear();
    overrideTitle = null;
    secondTitle = null; // Clear secondTitle as well
    overrideColor = null;
    _leadingAction = null;
    notifyListeners();

    // Reset the clearing flag after a delay to allow the new route to settle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 100), () {
        _isClearing = false;
      });
    });
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
        // Construct the combined title
        String displayTitle = AppBarController.instance.overrideTitle ?? title;
        if (AppBarController.instance.secondTitle != null) {
          displayTitle =
              '$displayTitle - ${AppBarController.instance.secondTitle}';
        }

        return AppBar(
          title: Text(displayTitle),
          automaticallyImplyLeading: automaticallyImplyLeading &&
              AppBarController.instance.leadingAction == null,
          leading: AppBarController.instance.leadingAction,
          backgroundColor: AppBarController.instance.overrideColor,
          actions: AppBarController.instance.actions,
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
