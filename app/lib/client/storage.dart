import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey {
  settingsPushService,
  settingsPushServiceIntervall,
  settingsPushServiceOngoing,
  settingsUseCountly,
  settingsSelectedColor,
  settingsSelectedTheme,
  settingsLoadApps,
  settingsUpdateAppsIntervall,

  userSchoolID,
  userUsername,
  userPassword,
  userSchoolName,
  userData,
  userSupportedApplets,

  substitutionsFilterKlassenStufe,
  substitutionsFilterKlasse,
  substitutionsFilterLehrerKuerzel,

  lastPushMessageHash,
  lastAppVersion,
  schoolImageLocation,
  schoolLogoLocation,
  schoolAccentColor,
}

extension SPHApp on StorageKey {
  String get key {
    switch (this) {
      case StorageKey.settingsPushService:
        return "settings-push-service-on";
      case StorageKey.settingsPushServiceIntervall:
        return "settings-push-service-interval";
      case StorageKey.settingsPushServiceOngoing:
        return "settings-push-service-notifications-ongoing";
      case StorageKey.settingsUseCountly:
        return "enable-countly";
      case StorageKey.settingsLoadApps:
        return "loadApps";
      case StorageKey.settingsUpdateAppsIntervall:
        return "updateAppsIntervall";
      case StorageKey.userSchoolID:
        return "schoolID";
      case StorageKey.lastAppVersion:
        return "last-app-version";
      case StorageKey.userUsername:
        return "username";
      case StorageKey.userPassword:
        return "password";
      case StorageKey.userSchoolName:
        return "schoolName";
      case StorageKey.userData:
        return "userData";
      case StorageKey.userSupportedApplets:
        return "supportedApps";
      case StorageKey.schoolImageLocation:
        return "schoolImageLocation";
      case StorageKey.schoolLogoLocation:
        return "schoolLogoLocation";
      case StorageKey.schoolAccentColor:
        return "schoolColor";
      case StorageKey.settingsSelectedColor:
        return "color";
      case StorageKey.settingsSelectedTheme:
        return "theme";
      case StorageKey.lastPushMessageHash:
        return "last-notifications-hash";
      case StorageKey.substitutionsFilterKlassenStufe:
        return "filter-klassenStufe";
      case StorageKey.substitutionsFilterKlasse:
        return "filter-klasse";
      case StorageKey.substitutionsFilterLehrerKuerzel:
        return "filter-lehrerKuerzel";
    }
  }

  String get defaultValue {
    switch (this) {
      case StorageKey.settingsPushService:
        return "true";
      case StorageKey.settingsPushServiceIntervall:
        return "15";
      case StorageKey.settingsUseCountly:
        return "true";
      case StorageKey.settingsUpdateAppsIntervall:
        return "15";
      case StorageKey.lastAppVersion:
        return "0.0.0";
      case StorageKey.userData:
        return "{}";
      case StorageKey.userSupportedApplets:
        return "[]";
      case StorageKey.settingsPushServiceOngoing:
        return "false";
      case StorageKey.settingsSelectedColor:
        return "standard";
      case StorageKey.settingsSelectedTheme:
        return "system";

      default:
        return "";
    }
  }
}


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
    required StorageKey key,
    required String value,
    bool secure = false,
  }) {
    if (secure) {
      return secureStorage.write(
        key: key.key,
        value: value,
        aOptions: _getAndroidOptions(),
      );
    } else {
      return prefs.setString(key.key, value);
    }
  }

  Future<String> read({required StorageKey key, secure = false}) async {
    // Ensure that prefs is initialized before accessing it
    await _initialize();

    if (secure) {
      return Future.value((await secureStorage.read(key: key.key, aOptions: _getAndroidOptions())) ?? key.defaultValue);
    } else {
      return Future.value(prefs.getString(key.key) ?? key.defaultValue);
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
