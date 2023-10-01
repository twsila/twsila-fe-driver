import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

import '../utils/resources/langauge_manager.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_ONBOARDING_SCREEN_VIEWED =
    "PREFS_KEY_ONBOARDING_SCREEN_VIEWED";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String USER_SELECTED_COUNTRY = "USER_SELECTED_COUNTRY";
const String DRIVER_MODEL = "DRIVER_MODEL";
const String DRIVER_FCM_TOKEN = "DRIVER_FCM_TOKEN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  String getAppLanguage() {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default lang
      return LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      // set english
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ENGLISH.getValue());
    } else {
      // set arabic
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ARABIC.getValue());
    }
  }

  Future<Locale> getLocal() async {
    String currentLang = getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      return ARABIC_LOCAL;
    } else {
      return ENGLISH_LOCAL;
    }
  }

  //driver functionalities
  Future<bool> setDriver(DriverBaseModel driver) async {
    setUserLoggedIn();
    String driverStr = json.encode(driver);
    await _sharedPreferences.setString(DRIVER_MODEL, driverStr);
    return true;
  }

  //Selected country
  setUserSelectedCountry(String country) {
    _sharedPreferences.setString(USER_SELECTED_COUNTRY, country);
  }

  String? getUserSelectedCountry() {
    return _sharedPreferences.getString(USER_SELECTED_COUNTRY);
  }

  //USER Firebase Token
  Future setFCMToken(String token) async {
    await _sharedPreferences.setString(DRIVER_FCM_TOKEN, token);
  }

  Future<String?> getFCMToken() async {
    return _sharedPreferences.getString(DRIVER_FCM_TOKEN);
  }

  DriverBaseModel? getCachedDriver() {
    Map<String, dynamic> driverMap = {};
    if (_sharedPreferences.getString(DRIVER_MODEL) != null &&
        _sharedPreferences.getString(DRIVER_MODEL) != "") {
      driverMap = jsonDecode(_sharedPreferences.getString(DRIVER_MODEL)!);
      driverMap["userDevice"] = UserDevice.fromJson(driverMap["userDevice"]);
    }
    if (driverMap["captainType"] == RegistrationConstants.businessOwner) {
      return driverMap.length != 0
          ? BusinessOwnerModel.fromCachedJson(driverMap)
          : null;
    } else {
      return driverMap.length != 0 ? Driver.fromJson(driverMap) : null;
    }
  }

  Future<bool> setRefreshedToken(String newToken) async {
    DriverBaseModel? driver = getCachedDriver();
    if (driver != null) {
      driver.token = newToken;
      await setDriver(driver);
      return true;
    } else {
      return false;
    }
  }

  bool? removeCachedDriver() {
    _sharedPreferences.setString(DRIVER_MODEL, "");
    return true;
  }

  // on boarding

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED) ??
        false;
  }

  //login

  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<void> setUserLoggedOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, false);
    Phoenix.rebirth(context);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
  }
}
