import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  late SharedPreferences prefs;
  final secureStorage = const FlutterSecureStorage();

  Storage() {
    _initialize();
  }

  Future<void> _initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  Future<void> write({
    required String key,
    required String value,
    bool secure = false,
  }) {
    if (secure) {
      return secureStorage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
      );
    } else {
      return prefs.setString(key, value);
    }
  }

  Future<String?> read({required String key, secure = false}) async {
    // Ensure that prefs is initialized before accessing it
    await _initialize();

    if (secure) {
      return secureStorage.read(key: key, aOptions: _getAndroidOptions());
    } else {
      return Future.value(prefs.getString(key));
    }
  }

  Future<void> deleteAll() {
    return Future.wait([
      prefs.clear(),
      secureStorage.deleteAll(aOptions: _getAndroidOptions())
    ]);
  }
}

Storage globalStorage = Storage();