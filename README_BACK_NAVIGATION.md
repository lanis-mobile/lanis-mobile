# Back Navigation Manager

A generic solution for handling custom back navigation in Flutter applets.

## Overview

The Back Navigation Manager allows any widget to register itself as a back navigation handler, enabling custom back button behavior while maintaining the app's navigation hierarchy.

## Files

- `lib/utils/back_navigation_manager.dart` - Core manager and interface
- `lib/examples/back_navigation_example.dart` - Usage examples
- `lib/home_page.dart` - Integration with main navigation

## How it Works

1. **Registration**: Widgets register themselves as back navigation handlers
2. **Priority**: The most recently registered handler gets first priority
3. **Fallback**: If no handler can handle the back action, normal navigation occurs

## Usage

### Method 1: Using BackNavigationMixin (Recommended)

```dart
class MyAppletState extends State<MyApplet> with BackNavigationMixin {
  @override
  Future<bool> canHandleBackNavigation() async {
    // Return true if you want to handle back navigation
    return hasUnsavedChanges || isInSpecialMode;
  }

  @override
  Future<bool> handleBackNavigation() async {
    // Handle the back action
    if (hasUnsavedChanges) {
      final shouldDiscard = await showDiscardDialog();
      return !shouldDiscard; // true = handled, false = let parent handle
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Your widget here
  }
}
```

### Method 2: Manual Implementation

```dart
class MyAppletState extends State<MyApplet> implements BackNavigationHandler {
  @override
  void initState() {
    super.initState();
    BackNavigationManager.registerHandler(this);
  }

  @override
  void dispose() {
    BackNavigationManager.unregisterHandler();
    super.dispose();
  }

  // Implement the interface methods...
}
```

## Common Use Cases

- **WebView Navigation**: Handle WebView back history before app navigation
- **Unsaved Changes**: Prompt user before discarding changes
- **Modal States**: Exit fullscreen, edit mode, etc.
- **Multi-step Forms**: Navigate between form steps
- **Custom UI States**: Handle special interaction modes

## Integration

The solution is integrated into `home_page.dart` and automatically checks registered handlers before performing default navigation:

```dart
// In home_page.dart PopScope
if (await BackNavigationManager.canHandleBackNavigation()) {
  await BackNavigationManager.handleBackNavigation();
  return; // Handler took care of it
}
// Continue with normal navigation...
```

## Example: Moodle WebView

The Moodle applet demonstrates real-world usage:

1. **WebView History**: If WebView can go back, it handles navigation internally
2. **View State**: If in WebView mode, it can switch to list mode
3. **Fallback**: Otherwise, normal app navigation occurs

This creates intuitive navigation where back button behavior adapts to the current context.
