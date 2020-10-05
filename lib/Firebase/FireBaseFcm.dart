import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/Preferences/MySharedPreference.dart';
import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FireBaseFcm {
  static FirebaseMessaging firebaseMessaging;

  MySharedPreferennce mySharedPreferennce = new MySharedPreferennce();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";

  FireBaseFcm() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (firebaseMessaging == null) {
      firebaseMessaging = FirebaseMessaging();
      firebaseConfiguration();
    }
  }

  //here i handle notification
  void firebaseConfiguration() {
    firebaseMessaging.requestNotificationPermissions();
    configLocalNotification();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _messageText = "Push Messaging message: $message";
        print("onMessage:" + message.toString());

        Platform.isAndroid
            ? showNotification(message)
            : showNotification(message);
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        _messageText = "Push Messaging message: $message";
        print("onLaunch:" + message.toString());
      },
      onResume: (Map<String, dynamic> message) async {
        _messageText = "Push Messaging message: $message";
        print("onResume: $message");
      },
    );
  }

  //here token generated for firebase push messege
  Future<void> notification(String id) async {
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    await firebaseMessaging.getToken().then((token) async {
      assert(token != null);
      print("fcm Token" + token);
      await mySharedPreferennce.setPushToken(token).then((onValue) {
        var data = {'fcmToken': token};
        Firestore.instance
            .collection('users')
            .document(MyConstants.user.uid)
            .updateData(data)
            .then((value) {
              MyConstants.fcmToken=token;
          print("Success");
        }).catchError((onError) {
          print(onError);
        });

      }).catchError((onError) {});
    });
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print(data.toString());
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print(notification.tostring);
    }

    // Or do other work.
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.example.project1' : 'com.example.project1',
      'Services Provider',
      'description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['data']['title'].toString(),
        message['data']['message'].toString(), platformChannelSpecifics,
        payload: json.encode(message) ?? json.encode("data"));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }
}
