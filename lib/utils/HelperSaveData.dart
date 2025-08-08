import 'dart:convert';

import 'package:bott/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/LoginUserModel.dart';

class HelperSaveData {
  HelperSaveData._();

  static HelperSaveData helperSaveData = HelperSaveData._();

  SharedPreferences? pref;

  Future<void> initSharedPreferences() async {
    pref ??= await SharedPreferences.getInstance();
  }

  Future<void> setStringValue(String name, String value) async {
    await initSharedPreferences();
    await pref!.setString(name, value);
  }

  Future<String?> getStringValue(String key) async {
    await initSharedPreferences();
    return pref!.getString(key);
  }

  // Save List of JSON Objects
  Future<void> saveLoginUsers(LoginUserModel? usersList) async {
    await initSharedPreferences();
    String usersJson = jsonEncode(usersList);
    await pref!.setString('login_users', usersJson);
  }

// Load List of JSON Objects
  Future<LoginUserModel?> loadLoginUsers() async {
    await initSharedPreferences();
    String? usersJson = pref!.getString('login_users');
    if (usersJson != null) {
      return LoginUserModel.fromJson(jsonDecode(usersJson));
    } else {
      return null;
    }
  }

  Future<void> setIntValue(String key, int value) async {
    await initSharedPreferences();
    await pref!.setInt(key, value);
  }

  Future<int?> getIntValue(String value) async {
    await initSharedPreferences();
    return pref!.getInt(value);
  }

  Future<void> saveDoubleValue() async {
    await initSharedPreferences();
    await pref!.setDouble("balance", 20.5);
  }

  Future<void> setBoolValue(String key, bool value) async {
    await initSharedPreferences();
    await pref!.setBool(key, value);
  }

  Future<bool?> getBoolValue(String value) async {
    await initSharedPreferences();
    return pref!.getBool(value);
  }

  Future<void> saveStringListValue(String key, List<String> list) async {
    await initSharedPreferences();
    await pref!.setStringList(key, list);
  }

  Future<List<String>?> getStringListValue(String list) async {
    await initSharedPreferences();
    return pref!.getStringList(list);
  }

  Future<bool> deleteValue(String key) async {
    await initSharedPreferences();
    return await pref!.remove(key);
  }

  Future<void> logout(BuildContext context) async {
    await initSharedPreferences();
    await pref!.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
