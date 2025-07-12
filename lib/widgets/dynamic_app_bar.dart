import 'package:flutter/material.dart';

/// A global controller to manage AppBar actions.
class AppBarController extends ChangeNotifier {
  AppBarController._();
  static final AppBarController instance = AppBarController._();

  final Map<String, Widget> _actions = {};
  String? overrideTitle;
  Color? overrideColor;

  List<Widget> get actions => List.unmodifiable(_actions.values);

  void add(String id, Widget action) {
    _actions[id] = action;
    notifyListeners();
  }

  void remove(String id) {
    if (_actions.remove(id) != null) {
      notifyListeners();
    }
  }

  void setOverrideTitle(String? title) {
    overrideTitle = title;
    notifyListeners();
  }

  Color setOverrideColor(Color? color) {
    overrideColor = color;
    notifyListeners();
    return overrideColor ?? Colors.transparent;
  }

  void clear() {
    _actions.clear();
    overrideTitle = null;
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
      builder: (context, _) => AppBar(
        title: Text(title),
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: AppBarController.instance.overrideColor,
        actions: AppBarController.instance.actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
