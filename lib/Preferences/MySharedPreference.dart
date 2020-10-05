import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferennce {
  static String User_Login_Data = "User_Login_Data";
  static String Push_Token = "Push_Token";
  static String User_Id = "User_Id";
  static String User_Email = "User_Email";
  static String User_Name = "User_Name";
  static String User_Image = "User_Image";
  static String token = "User_Token";
  static String user_address = "Address";
  static String phone_number = "Phone_Number";
  static String FCM_Token = "FCM_Token";

  Future LoginSession(FirebaseUser user) async {
    var result;

    MyConstants.id = user.uid;
    MyConstants.email = user.email;
    MyConstants.userImage=user.photoUrl?? MyConstants.default_image_url;
    MyConstants.phoneNumber=user.phoneNumber;
    MyConstants.userName =user.displayName;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs?.setString(User_Id, user.uid);
    await prefs?.setString(User_Email, user.email);
    await prefs?.setString(phone_number, user.phoneNumber);
    await prefs?.setString(User_Name, user.displayName);
    await prefs?.setString(User_Image, user.photoUrl);

    MyConstants.user=user;

    await prefs
        ?.setString(User_Login_Data, json.encode(user))
        .then((onValue) {
      print("savingResponse : Saved Successfully");
      result = true;
    }).catchError((onError) {
      print("savingResponse : Failed to Save");
      result = false;
    });
    return result;
  }

  Future setPushToken(String Token) async {
    var result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MyConstants.token = Token;
    await prefs?.setString(Push_Token, Token).then((onValue) {
      result = true;
    }).catchError((onError) {
      result = false;
    });
  }

  Future getPushToken() async {
    var result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data1 = await prefs?.getString(Push_Token) ?? "token";
    MyConstants.token = data1;
    print("get token" + data1);
    return data1;
  }

  Future getUserrLogIn() async {
    var data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data1 = await prefs?.getString(User_Login_Data) ?? "logout";
    print("get Login" + data1);
    if (data1 != "logout") {
      MyConstants.id = await prefs?.getString(User_Id);
      MyConstants.email = await prefs?.getString(User_Email);
      MyConstants.phoneNumber = await prefs?.getString(phone_number);
      MyConstants.userName = await prefs?.getString(User_Name);
      MyConstants.userImage = await prefs?.getString(User_Image)?? MyConstants.default_image_url;
      MyConstants.token = await prefs?.getString(token);
      SharedPreferences newPref = await SharedPreferences.getInstance();
//      FirebaseUser newData =FirebaseUser.fromJson( json.decode(await prefs?.getString(User_Login_Data) ?? "logout"));
//      MyConstants.loginResponse=newData;
      data = json.decode(await prefs?.getString(User_Login_Data) ?? "logout");
    } else {
      data = await prefs?.getString(User_Login_Data) ?? "logout";
    }
    return data;
  }
  Future<FirebaseUser> getUserData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
//       FirebaseUser data =FirebaseUser(s).fromJson( json.decode(await prefs?.getString(User_Login_Data) ?? "logout"));
//      return data;
    }

  void userLogOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(User_Login_Data, "logout").then((onValue) {
      print("savingResponse : User LogOut Successfully");
    }).catchError((onError) {
      print("savingResponse : User LogOut Failed");
    });
  }

  Future getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data1 = await prefs?.getString(User_Id) ?? "logout";
    print("get Login" + data1);
    return data1;
  }


  Future setFCMToken(String Token) async {
    var result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    MyConstants.token = Token;
    await prefs?.setString(FCM_Token, Token).then((onValue) {
      result = true;
    }).catchError((onError) {
      result = false;
    });
  }


  Future getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data1 = await prefs?.getString(FCM_Token) ?? "";
    MyConstants.FCMToken = data1;
    print("get FCM Token " + data1);
    return data1;
  }

}
