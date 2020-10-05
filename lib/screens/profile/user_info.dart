import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/Firebase/firebase_auth_provider.dart';
import 'package:inline/Preferences/MySharedPreference.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/inputfield.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  TextEditingController nameController=TextEditingController(text: MyConstants.user.displayName);
  TextEditingController emailController=TextEditingController(text: MyConstants.user.email);

  File _image;

  final StorageReference ref = FirebaseStorage.instance.ref();
  String _uploadedFileURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        child: SafeArea(
          child: Container(
            height: 200,
            decoration: BoxDecoration(color: myLightColor, boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 0.5,
                  color: Colors.grey.withOpacity(0.1),
                  offset: Offset(0, 1))
            ]),
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: ()async{
                    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

                    setState(() {
                      MyConstants.showLoadingBar(context);
                      _image = image;
                      uploadFile();
                    });
                  },
                  child:_image!=null?
                      Image.file(_image, width:MyConstants.width,
                        fit: BoxFit.fill,)
                  :Center(child: MyConstants.user.photoUrl!=null?
                  CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                      ),
                    ),
                    imageUrl: MyConstants.user.photoUrl,
                    fit: BoxFit.cover,
                  ):CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                      ),
                    ),
                    imageUrl: MyConstants.default_image_url,
                    fit: BoxFit.cover,
                  ),)
//                  CircleAvatar(
//                    maxRadius: 50,
//                    child:
//                    MyConstants.user.photoUrl!=null?
//                    Image.network(
//                      MyConstants.user.photoUrl,
//                      fit: BoxFit.fill,
//                    ):Image.network(
//                      MyConstants.default_image_url,
//                      fit: BoxFit.fill,
//                    ),
//                  ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        child: Material(
                          shape: CircleBorder(),
                          color: Colors.transparent,
                          child: InkWell(
                            customBorder: CircleBorder(),
                            splashColor: Colors.deepOrange[100],
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              size: 32,
                              color: myWhiteColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () async {
                            MyConstants.showLoadingBar(context);
                            FirebaseUser user = await FirebaseAuthProvider().createOrUpdate('','',nameController.text,_uploadedFileURL);
                            if(user!=null){

                              await Firestore.instance.collection('users').document(user.uid).updateData({
                                'name': user.displayName,
                                'image' : user.photoUrl
                              });
                              user=await FirebaseAuthProvider().getCurrentUser();
                              setState(() {
                                MyConstants.user=user;
                              });
                              MySharedPreferennce().LoginSession(user);
                              MyConstants.hideLoadingBar();
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Save',
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: myWhiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    child: Material(
                      shape: CircleBorder(),
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: CircleBorder(),
                        splashColor: Colors.deepOrange[100],
                        onTap: () async {
                          var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                          setState(() {
                            MyConstants.showLoadingBar(context);
                            _image = image;
                            uploadFile();
                          });
                        },
                        child: Icon(
                          Icons.add_a_photo,
                          size: 32,
                          color: myWhiteColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(200),
      ),
      backgroundColor: myWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  'Edit my profile',
                  style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: myBlackColor),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              secondayInputField(hintText: 'Name',controller: nameController,editable: true),
              secondayInputField(hintText: 'Email',controller: emailController,keyboardType: TextInputType.emailAddress,editable: false),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 58,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: myWhiteColor,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      print("Clicked");
                    },
                    splashColor: Colors.deepOrange[100],
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 0, right: 10),
                          child: Text('Change Password',
                              style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: myBlackColor)),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("images/"+_image.path);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String s=await storageReference.getDownloadURL();
    _uploadedFileURL=s;
    setState(() {
      MyConstants.hideLoadingBar();
    });
  }
}
