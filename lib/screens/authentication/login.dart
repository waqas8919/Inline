import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/Firebase/FireBaseFcm.dart';
import 'package:inline/Firebase/firebase_auth_provider.dart';
import 'package:inline/Preferences/MySharedPreference.dart';
import 'package:inline/screens/authentication/register.dart';
import 'package:inline/screens/home/home.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/inputfield.dart';

import '../../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Global Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();

  List<DocumentSnapshot> usersList=List<DocumentSnapshot>();

  //text controller
  TextEditingController userEmailTextConroller = new TextEditingController();
  TextEditingController userPasswordTextConroller = new TextEditingController();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool isTrue=false;


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS ;
  var initializationSettings;

  //error variable
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Image.asset(
                        'assets/images/inline-logo.png',
                        width: 150.0,
                        height: 150.0,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Login',
                            style: GoogleFonts.openSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: myBlackColor),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Text(
                            'Please sign in to continue',
                            style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: myDarkGreyColor),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                primaryInputField(
                                  label: "Email",
                                  hintText: "your@email.com",
                                  keyboardType: TextInputType.emailAddress,
                                  controllerName: userEmailTextConroller,
                                  valueStatus: (String value) {
                                    if (value.isEmpty) {
                                      return 'Email is required';
                                    }
                                    if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                      return 'Please input a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                primaryInputField(
                                    formFieldKey: _passKey,
                                    label: "Password",
                                    hintText: "enter your password here",
                                    obscureText: true,
                                    controllerName: userPasswordTextConroller,
                                    valueStatus: (value) {
                                      if (value.isEmpty)
                                        return 'Please Enter password';
                                      if (value.length < 8)
                                        return 'Password should be more than 8 characters';
                                      return null;
                                    }),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Text(
                                    error,
                                    style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red[600]),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  width: 300,
                                  height: 56,
                                  child: FlatButton(
                                    color: myPrimaryColor,
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          MyConstants.showLoadingBar(context);
                                        });

                                        try {
                                          var s=await FirebaseAuthProvider().signInWithEmail(userEmailTextConroller.text, userPasswordTextConroller.text);
                                          FirebaseUser user=await FirebaseAuthProvider().getCurrentUser();
                                          if(user!=null){
                                            final QuerySnapshot result =
                                            await Firestore.instance.collection('users').getDocuments();
                                            final List<DocumentSnapshot> documents = result.documents;
                                            MyConstants.users.clear();
                                            MyConstants.users .addAll(result.documents) ;

                                            setState(() {
                                              usersList.clear();
                                              usersList.addAll(documents);
                                            });

                                            for(int i=0;i<usersList.length;i++){
                                              if(usersList[i].documentID==user.uid){
                                                isTrue=true;
                                                break;
                                              }
                                            }

                                            if(!isTrue){
                                              await Firestore.instance.collection('users').document(user.uid).setData({
                                                'id':user.uid,
                                                'email':user.email,
                                                'name': user.displayName,
                                                'image': user.photoUrl
                                              });
                                            }

                                            MyConstants.user=user;
                                            MySharedPreferennce().LoginSession(user);
                                            _firebaseMessaging.configure(
                                              onMessage: (Map<String, dynamic> message) async {
                                                initializationSettingsIOS = IOSInitializationSettings(
                                                    onDidReceiveLocalNotification: onDidReceiveLocalNotification);
                                                initializationSettings= InitializationSettings(
                                                    initializationSettingsAndroid, initializationSettingsIOS);
                                                print("onMessage:"+message.toString());
                                              },
                                              onLaunch: (Map<String, dynamic> message) async {
                                                print("onLaunch:"+ message.toString());
                                              },
                                              onResume: (Map<String, dynamic> message) async {
                                                print("onResume: $message");
                                              },
                                            );
                                            await FireBaseFcm().notification(user.uid);
                                            initFcm();
                                            setState(() {
                                              MyConstants.hideLoadingBar();
                                            });
                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
                                          }else{
                                            MyConstants.hideLoadingBar();
                                            Flushbar(
                                              title: "Sign In Error",
                                              message: s.toString(),
                                              duration: Duration(seconds: 5),
                                            )..show(context);
                                          }
                                        } catch (e) {
                                          MyConstants.hideLoadingBar();
                                          Flushbar(
                                            title: "Sign In Error",
                                            message: e.toString(),
                                            duration: Duration(seconds: 5),
                                          )..show(context);
                                          print("Sign In Error: "+e.toString());
                                          String exception = FirebaseAuthProvider.getExceptionText(e);
                                          Flushbar(
                                            title: "Sign In Error",
                                            message: exception,
                                            duration: Duration(seconds: 5),
                                          )..show(context);
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Login",
                                      style: GoogleFonts.openSans(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: myWhiteColor),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Join us and create an account?',
                                        style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: myBlackColor),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (BuildContext context) => Register())
                                          );
                                        },
                                        child: Text(
                                          'Signup',
                                          style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: myPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
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

      await _firebaseMessaging.getToken().then((String token) async {
        assert(token != null);
        await mySharedPreferennce.setFCMToken(token);
//      print(_homeScreenText);
      });
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
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
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
