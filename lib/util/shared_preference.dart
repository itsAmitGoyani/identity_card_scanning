import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:identity_card_scanning/models/login_model.dart';

late SharedPreferences sharedPreferences;
const String authData = "authData";
const String username = "username";
const String rememberMe = "rememberMe";

Future<void> initSharedPref() async {
  sharedPreferences = await SharedPreferences.getInstance();
}

// User personal details
Future<void> setAuthData(LoginModel model) async {
  final data = model.toJson();
  await sharedPreferences.setString(authData, json.encode(data));
}

LoginModel? get getAuthData {
  final data = sharedPreferences.getString(authData);
  if (data != null) {
    return LoginModel.fromJson(json.decode(data));
  }
  return null;
}

Future<void> removeAuthData() async {
  await sharedPreferences.remove(authData);
}

Future<void> setUsername(String data) async {
  await sharedPreferences.setString(username, data);
}

String? get getUsername {
  return sharedPreferences.getString(username);
}

Future<void> removeUsername() async {
  await sharedPreferences.remove(username);
}

Future<void> setRememberMe(bool data) async {
  await sharedPreferences.setBool(rememberMe, data);
}

bool? get getRememberMe {
  return sharedPreferences.getBool(rememberMe);
}

Future<void> removeRememberMe() async {
  await sharedPreferences.remove(rememberMe);
}
