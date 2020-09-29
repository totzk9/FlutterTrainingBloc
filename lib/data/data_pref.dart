import 'package:shared_preferences/shared_preferences.dart';

class DataPreferences {
  static final DataPreferences _instance = DataPreferences._contructor();
  factory DataPreferences() {
    return _instance;
  }

  DataPreferences._contructor();

  SharedPreferences _preferences;
  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  getStringData(String key) {
    return _preferences.getString(key);
  }

  setStringData(String key, String value) {
    _preferences.setString(key, value);
  }

  getIntData(String key) {
    return _preferences.getInt(key);
  }

  setIntData(String key, int value) {
    _preferences.setInt(key, value);
  }
}
