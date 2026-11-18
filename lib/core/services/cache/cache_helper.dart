import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  //! Initialize the shared preferences
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  ///Keys
  static const String TOKEN = 'access_token';
  static const String LANG_CODE = 'lang_code';
  static const String REFRESH_TOKEN_EXPIRE = 'refresh_token_expire_in_seconds';
  static const String REFRESH_TOKEN = 'refresh_token';
  static const String LOGIN_TIME = 'login_time';
  static const String USER = 'user';
  static const String ROLE = 'role';

  //! General method to save any type of data
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    if (value is bool) return await _sharedPreferences.setBool(key, value);
    if (value is double) return await _sharedPreferences.setDouble(key, value);
    if (value is List<String>) {
      return await _sharedPreferences.setStringList(key, value);
    }

    return false;
  }

  //! General method to get any type of data
  static dynamic getData({required String key}) {
    return _sharedPreferences.get(key);
  }

  //! Specialized method for String (optional but handy)
  static String? getString({required String key}) {
    return _sharedPreferences.getString(key);
  }

  //! Check if key exists
  static bool containsKey({required String key}) {
    return _sharedPreferences.containsKey(key);
  }

  //! Remove specific data using a key
  static Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

  //! Clear ALL data from local storage
  static Future<bool> clearAllData() async {
    return await _sharedPreferences.clear();
  }

  static Future setAccessToken(String? token) async {
    await saveData(key: TOKEN, value: token);
  }

  static String getAccessToken() {
    return getString(key: TOKEN) ?? '';
  }

  static Future cacheUserModel(Map<String, dynamic>? userInfo) async {
    await saveData(key: USER, value: jsonEncode(userInfo));
  }

  // static UserModel? getCachedUserModel() {
  //   if (getData(key: USER) != null) {
  //     return UserModel.fromJson(
  //       jsonDecode(getData(key: USER) ?? "{}") as Map<String, dynamic>,
  //     );
  //   }
  //   return null;
  // }

  // static void disposeUser() {
  //   //* save printers before logout or clean
  //   const String printersKey = 'printer_module_v2_printers';
  //   final String? printersData = _sharedPreferences.getString(printersKey);

  //   _sharedPreferences.clear();

  //   //* restor printers
  //   if (printersData != null) {
  //     _sharedPreferences.setString(printersKey, printersData);
  //   }
  // }
}
