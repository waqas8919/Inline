import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inline/Firebase/firebase_auth_provider.dart';
import 'package:inline/Preferences/MySharedPreference.dart';
import 'package:inline/screens/authentication/login.dart';
import 'package:inline/screens/home/home.dart';

import 'Constants/MyConstants.dart';
import 'Firebase/FireBaseFcm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
      statusBarColor: Color(0xffd86a5a),
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }




}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {





//  MySharedPreferennce mySharedPreferennce=MySharedPreferennce();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    MyConstants.width = MediaQuery.of(context).size.width;
    MyConstants.height = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Container(
        width: MyConstants.width,
        height: MyConstants.height,
//        child: Image.asset('assets/splash.png', fit: BoxFit.fill,),
      ),
//      Stack(
//        children: <Widget>[
//          Image.asset('assets/images/cropdrop.png',fit: BoxFit.fill,repeat: ImageRepeat.noRepeat,),
//          // Positioned(bottom: 10,child: Center(child: Container(height: MediaQuery.of(context).size.height/3,width:MediaQuery.of(context).size.width/2 , child: LoadingIndicator(indicatorType: Indicator.ballRotateChase, color: Colors.white,))))
//          //Center(child: Container(height: MediaQuery.of(context).size.height/3,width:MediaQuery.of(context).size.width/2 , child: LoadingIndicator(indicatorType: Indicator.ballRotateChase, color: Colors.white,)))
//        ],
//      ),
    );
  }

  _startTimer(BuildContext context) async {
    Future.delayed(Duration(seconds: 0), navigationPage);
  }

  navigationPage() async {
    bool isSignedIn= await FirebaseAuthProvider().isUserSignIn();
//    MySharedPreferennce sharedPreferennce=MySharedPreferennce();
//    var data = await sharedPreferennce.getUserrLogIn();
    if(isSignedIn!=null && isSignedIn!=false){
      FireBaseFcm firebaseFcm = FireBaseFcm();
      var user= await FirebaseAuthProvider().getCurrentUser();
      String  token= await MySharedPreferennce().getPushToken();
      MyConstants.user=user;
      MyConstants.fcmToken=token;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    }else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    }

  }



}