import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inline/Preferences/MySharedPreference.dart';
import 'package:inline/screens/home/profile.dart';


import '../../main.dart';
import 'homebody.dart';
import 'myqueue.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS ;
  var initializationSettings;


  //variable
  int _currentIndex = 0;

  //switch screens
  changeScreen(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomeBody();
        break;
      case 1:
        return MyQueue();
        break;
      case 2:
        return Profile();
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    initFcm();
    notification();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          _currentIndex = value;
          setState(() {});
        },
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue),
            title: Text('My Queue'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
        ],
        iconSize: 28,
        selectedItemColor: Color(0xfff27360),
        unselectedItemColor: Color(0xff36374c),
      ),
      backgroundColor: Colors.white,
      body: changeScreen(_currentIndex),
    );
  }

  Future<void> notification() async {
    MySharedPreferennce mySharedPreferennce=MySharedPreferennce();
    String oldToken=await mySharedPreferennce.getFCMToken();
    if(oldToken==null || oldToken==""){
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });

//      await _firebaseMessaging.getToken().then((String token) async {
//        assert(token != null);
//        await mySharedPreferennce.setFCMToken(token).then((onValue){
//          ApiCall.addToken(token).then((onValue){
//            MyConstants.FCMToken=token;
//            print('Token added successfully');
//            print("token:"+token.toString());
//          }).catchError((onError){
//
//          });
//
//
//        }).catchError((onError){
//        });
////      print(_homeScreenText);
//      });
    }




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


  Future<void> _handleNotification (Map<dynamic, dynamic> message, bool dialog) async {
    var data = message['data'] ?? message;
    String expectedAttribute = data['expectedAttribute'];
    /// [...]
  }

  Future<void> initFcm() async {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }


}
