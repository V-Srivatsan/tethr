import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static final _storage = FlutterSecureStorage();

  static const TOKEN = "token", REFRESH_TOKEN = "refresh_token", NAME = "name";

  static Future<String?> get(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> set(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}


class PrefStore {
  static final _pref = SharedPreferencesAsync();

  static Future<bool?> getTheme() async {
    return await _pref.getBool("dark_theme");
  }

  static void setTheme(bool? dark) async {
    if (dark == null) await _pref.remove("dark_theme");
    else await _pref.setBool("dark_theme", dark);
  }

  static Future<bool> isDisasterMode() async {
    return await _pref.getBool("disaster_mode") ?? false;
  }

  static void setDisasterMode(bool value) async {
    await _pref.setBool("disaster_mode", value);
  }

  static Future<void> clear() async {
    await _pref.clear();
  }
}