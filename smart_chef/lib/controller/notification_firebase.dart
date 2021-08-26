import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:smart_chef/controller/get_auth.dart';
import 'get_home.dart';

class NotificationHelper {
  String token = '';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  Map<String, dynamic> message = {};
  HomeGet apiGet = Get.find();
  AuthGet auth = Get.find();
  initialNotification() {
    getToken();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            alert: true, badge: true, provisional: true, sound: true));
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        this.message = message;
        // showNotification(
        //   message['notification']['title'],
        //   message['notification']['body'],
        // );
        apiGet.getDashboard();
        apiGet.playAlert();
      },
      onLaunch: (Map<String, dynamic> message) async {
        this.message = message;
      },
      onResume: (Map<String, dynamic> message) async {
        this.message = message;
      },
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {}
  }

  void showNotification(String title, String body) async {
    await _demoNotification(
      title,
      body,
    );
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker',
        sound: RawResourceAndroidNotificationSound("assets/sounds/alert.mp3"));
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  getToken() async {
    firebaseMessaging
        .subscribeToTopic('${auth.domenController.value.text ?? "all"}');
    token = await firebaseMessaging.getToken();

    return token;
  }
}
