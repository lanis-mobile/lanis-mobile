import 'package:lanis/home_page.dart';

class BottomNavBarChangeNotifier {
  BottomNavBarChangeNotifier._();
  static final BottomNavBarChangeNotifier instance =
      BottomNavBarChangeNotifier._();

  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void setVisible(bool visible) {
    _isVisible = visible;
    homeKey.currentState?.updateShowBottomAppBar(visible);
  }
}
