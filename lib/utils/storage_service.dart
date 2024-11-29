import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '/constants/strings.dart';
import '/models/user_model.dart';
/*
using shared prefernces to cash data (theme prefrences,notification prefrences, login's state )
 
storing and reading data from shared preferences is necessary
 to ensure that the data remains accessible
 even when the user closes the app or restarts their device, 

*/
class StorageService {
  static late SharedPreferences _sharedPreferences;

  static Future<void> saveUser(UserModel userModel) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(
        PREFS_KEY, json.encode(userModel.toMap(userModel)));
  }

  static Future<UserModel?> readUser() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString(PREFS_KEY) == null
        ? null
        : UserModel.fromMap(
            json.decode(_sharedPreferences.getString(PREFS_KEY)!));
  }

  static Future<void> clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }
}
