import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';

class FirebaseMessagingHelper extends ChangeNotifier {
  static final _fbm = FirebaseMessaging.instance;
  static ValueNotifier<int> notificationCounter = ValueNotifier(0);
  static final AppPreferences appPreferences = instance<AppPreferences>();

  Future<void> configure(BuildContext context) async {
    _fbm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    _fbm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      // If the application has been opened from a terminated state via a RemoteMessage (containing a Notification), it will be returned, otherwise it will be null.
      // Once the RemoteMessage has been consumed, it will be removed and further calls to getInitialMessage will be null.

      if (message != null) {
        dynamic notification = message.data;
        print(message);
        FirebaseMessagingHelper.navigateToNotifications(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dynamic notification = message.data;
      notificationCounter.value += 1;
      return;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await navigateToNotifications(message);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await setFcmToken();
  }

  static Future<void> navigateToNotifications(RemoteMessage message) async {
    await SharedPreferences.getInstance();

    print(message);
  }

  static Future<void> setFcmToken() async {
    await _fbm.getToken().then((token) {
      log("FCM token : $token");
      FirebaseMessagingHelper.appPreferences.setFCMToken(token!);
    }).onError((error, stackTrace) {
      print("FCM token error: $error");
    });
  }

  static _showDialog(String message, BuildContext context) {}

  static _hideDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  FirebaseMessagingHelper.notificationCounter.value += 1;
}
