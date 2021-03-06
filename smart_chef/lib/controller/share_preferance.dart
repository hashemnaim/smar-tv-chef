import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_chef/model/user.dart';

class ShereHelper {
  ShereHelper._();

  static ShereHelper sHelper = ShereHelper._();

  SharedPreferences sharedPreferences;

  Future<SharedPreferences> initSharedPrefrences() async {
    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences;
    } else {
      return sharedPreferences;
    }
  }

  static const USER = 'user';

  Future<void> setUser(User user) async {
    sharedPreferences = await initSharedPrefrences();
    String userJson = jsonEncode(user);
    return sharedPreferences.setString(USER, userJson);
  }

  String getToken() {
    String x = sharedPreferences.getString('accessToken');
    return x;
  }

  String getDomin() {
    String x = sharedPreferences.getString('domin');
    return x;
  }

  String getName() {
    String x = sharedPreferences.getString('name');
    return x;
  }

  String getPassword() {
    String x = sharedPreferences.getString('password');
    return x;
  }

  setPassword(String value) {
    sharedPreferences.setString('password', value);
  }

  setName(String value) {
    sharedPreferences.setString('name', value);
  }

  setDomin(String value) {
    sharedPreferences.setString('domin', value);
  }

  setToken(String value) {
    sharedPreferences.setString('accessToken', value);
  }

  addNew(String key, String value) async {
    sharedPreferences = await initSharedPrefrences();
    sharedPreferences.setString(key, value);
  }

  Future<User> getUser() async {
    sharedPreferences = await initSharedPrefrences();

    String user = sharedPreferences.getString(USER);
    if (user != null) {
      var map = jsonDecode(sharedPreferences.getString(USER));
      return User.fromJson(map);
    } else {
      return null;
    }
  }

  Future<String> getValue(String key) async {
    sharedPreferences = await initSharedPrefrences();
    String x = sharedPreferences.getString(key);
    return x;
  }

  int getNumberOrdersDelivery() {
    int number = sharedPreferences.getInt('numberOrders');
    return number;
  }

  setNumberNotificationDelivery(int value) {
    sharedPreferences.setInt('NumberNotificationDelivery', value);
  }

  int getNumberNotificationDelivery() {
    int number = sharedPreferences.getInt('NumberNotificationDelivery');
    return number;
  }

  setNumberNotificationOsra(int value) {
    sharedPreferences.setInt('NumberNotificationOsra', value);
  }

  int getNumberNotificationOsra() {
    int number = sharedPreferences.getInt('NumberNotificationOsra');
    return number;
  }

  void removeUser() async {
    sharedPreferences = await initSharedPrefrences();
    sharedPreferences.remove(USER);
  }
}
