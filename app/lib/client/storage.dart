import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final storage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  Future<void> write({required String key, required String value}) {
    return storage.write(key: key, value: value, aOptions: _getAndroidOptions());
  }

  Future<String?> read({   required String key}){
    return storage.read(key: key, aOptions: _getAndroidOptions());
  }

  Future<void> deleteAll() {
    return storage.deleteAll(aOptions: _getAndroidOptions());
  }
}

Storage globalStorage = Storage();