import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/Firebase/FireBaseFcm.dart';
import 'package:inline/Firebase/firebase_auth_provider.dart';
import 'package:inline/Preferences/MySharedPreference.dart';
import 'package:inline/screens/home/home.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/inputfield.dart';
import 'package:quiver/strings.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:firebase_auth/firebase_auth.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

//Global Key
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
var _passKey = GlobalKey<FormFieldState>();

class _RegisterState extends State<Register> {
  //text controller
  TextEditingController userNameTextConroller = new TextEditingController();
  TextEditingController userEmailTextConroller = new TextEditingController();
  TextEditingController userPasswordTextConroller = new TextEditingController();
  TextEditingController userRetypePasswordTextConroller =
      new TextEditingController();

  //error variable
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
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
                              'Create Account',
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
                              'Please create your account',
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
                                    label: "Name",
                                    hintText: "input your name",
                                    keyboardType: TextInputType.text,
                                    controllerName: userNameTextConroller,
                                    valueStatus: (String value) {
                                      if (value.isEmpty) {
                                        return 'Name is required';
                                      }
                                      return null;
                                    },
                                  ),
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
                                  primaryInputField(
                                    label: "Retype Password",
                                    hintText: "retype your password here",
                                    obscureText: true,
                                    controllerName:
                                        userRetypePasswordTextConroller,
                                    valueStatus: (confirmPassword) {
                                      if (confirmPassword.isEmpty)
                                        return 'Enter confirm password';
                                      var password =
                                          _passKey.currentState.value;
                                      if (!equalsIgnoreCase(
                                          confirmPassword, password))
                                        return 'Confirm Password invalid';
                                      return null;
                                    },
                                  ),
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
                                      onPressed: () async{
                                        if (_formKey.currentState.validate()) {
                                          try {
                                             setState(() {
                                         MyConstants.showLoadingBar(context);
                                       });
                                            FirebaseUser user = await FirebaseAuthProvider().createOrUpdate(userEmailTextConroller.text, userPasswordTextConroller.text,userNameTextConroller.text,'');
                                            if(user!=null){

                                              await Firestore.instance.collection('users').document(user.uid).setData({
                                                'id':user.uid,
                                                'email':user.email,
                                                'name': user.displayName,
                                              });
                                              final QuerySnapshot result =
                                              await Firestore.instance.collection('users').getDocuments();
                                              MyConstants.users.clear();
                                              MyConstants.users .addAll(result.documents) ;
                                              await FireBaseFcm().notification(user.uid);
                                              MySharedPreferennce().LoginSession(user);
                                              setState(() {
                                              MyConstants.hideLoadingBar();
                                            });
                                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
                                            }
                                          } catch (e) {
                                            setState(() {
                                              MyConstants.hideLoadingBar();
                                            });;
                                            print("Sign Up Error: $e");
                                            String exception = FirebaseAuthProvider.getExceptionText(e);
                                            Flushbar(
                                              title: "Sign Up Error",
                                              message: exception,
                                              duration: Duration(seconds: 5),
                                            )..show(context);
                                          }


                                        }
                                      },
                                      child: Text(
                                        "Sign up",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Already have an account?',
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
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Login',
                                            style: GoogleFonts.openSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: myPrimaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 80,
                                  ),
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
          ],
        ),
      ),
    );
  }
}
