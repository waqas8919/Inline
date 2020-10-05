import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/buttons.dart';
import 'package:inline/widgets/inputfield.dart';

class UpdateQueue extends StatefulWidget {
  @override
  _QueueState createState() => _QueueState();
}

class _QueueState extends State<UpdateQueue> {

  File _image;
  final picker = ImagePicker();
  bool isImage=true;
  final StorageReference ref = FirebaseStorage.instance.ref();
  String _uploadedFileURL=MyConstants.updateQueue.data['image'];

//  'createdBy':MyConstants.user.uid,
//  'image': _uploadedFileURL,
//  'hostName':nameController.text,
//  'hostAddress': addressController.text,
//  'description': descriptionController.text,
//  'visitorLimit': int.parse(visitorLimitController.text),
//  'queueLimit': int.parse(queueLimitController.text),
//  'isCompleted':false,
//  'visitors':data

  TextEditingController nameController=TextEditingController(text: MyConstants.updateQueue.data['hostName']);
  TextEditingController addressController=TextEditingController(text: MyConstants.updateQueue.data['hostAddress']);
  TextEditingController descriptionController=TextEditingController(text: MyConstants.updateQueue.data['description']);
  TextEditingController visitorLimitController=TextEditingController(text: MyConstants.updateQueue.data['visitorLimit'].toString());
  TextEditingController queueLimitController=TextEditingController(text: MyConstants.updateQueue.data['queueLimit'].toString());

//   DatabaseReference RootRef;
//   String currentUserID;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: myWhiteColor, boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 0.5,
                  color: Colors.grey.withOpacity(0.1),
                  offset: Offset(0, 1))
            ]),
            child: Padding(
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
                          color: myBlackColor,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Update Queues',
                    style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: myBlackColor),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(100),
      ),
      backgroundColor: myWhiteColor,
      body: SafeArea(
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(20),
              children: <Widget>[
                Container(
                  child: Text(
                    'update your queue',
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: myBlackColor),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        secondayInputField(
                            controller: nameController,
                            label: 'Host Name',
                            maxLines: 1,
                            maxLength: 20,
                            keyboardType: TextInputType.text,
                            hintText: 'Store, shop, or service name'),
                        secondayInputField(
                            controller: addressController,
                            label: 'Host Address',
                            maxLines: 2,
                            maxLength: 100,
                            keyboardType: TextInputType.text,
                            hintText: 'Store, service, or host address'),
                        secondayInputField(
                            controller: descriptionController,
                            label: 'Description',
                            maxLines: 3,
                            maxLength: 200,
                            keyboardType: TextInputType.multiline,
                            hintText: 'Add some description about your queue '),
                        secondayInputField(
                            controller: visitorLimitController,
                            label: 'Visitor Limit',
                            sublabel:
                            'This controls how many visitors in your queue to enter at once',
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            hintText: '4'),
                        secondayInputField(
                            controller: queueLimitController,
                            label: 'Queue Limit',
                            sublabel:
                            'This controls how many visitors can be in your queue at one time.',
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            hintText: '4'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Text(
                    'Upload photo',
                    style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: myBlackColor),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap:() async {
                    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                    isImage=false;
                    setState(() {
                      MyConstants.showLoadingBar(context);
                      _image = File(image.path);
                      uploadFile();
                    });

                  } ,
                  child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child: iconButton(icon: Icons.photo_camera, trigger: () {}),
                          ),
                          Container(
                            width: MyConstants.width*0.7,
                            child: Text(
                              _uploadedFileURL!=null?_uploadedFileURL:'select image',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: myBlackColor),
                            ),
                          )
                        ],
                      )),
                ),
                SizedBox(
                  height: 50,
                ),
                primaryButton(label: 'Update Queue', trigger: () async {
                  if(isImage){
                    MyConstants.showLoadingBar(context);
                    String s= DateTime.now().millisecondsSinceEpoch.toString();
                    List<String> UserQueues=List<String>();

                    if(_uploadedFileURL!=null){
                      await Firestore.instance.collection('Queues').document(MyConstants.updateQueue.documentID).updateData({
                        'createdBy':MyConstants.user.uid,
                        'image': _uploadedFileURL,
                        'hostName':nameController.text,
                        'hostAddress': addressController.text,
                        'description': descriptionController.text,
                        'visitorLimit': int.parse(visitorLimitController.text),
                        'queueLimit': int.parse(queueLimitController.text),
                      });
                    }else{
                      await Firestore.instance.collection('Queues').document(MyConstants.updateQueue.documentID).updateData({
                        'createdBy':MyConstants.user.uid,
                        'hostName':nameController.text,
                        'hostAddress': addressController.text,
                        'description': descriptionController.text,
                        'visitorLimit': int.parse(visitorLimitController.text),
                        'queueLimit': int.parse(queueLimitController.text),
                      });
                    }


                    setState(() {
                      MyConstants.isDocumentGot=false;
                      MyConstants.hideLoadingBar();
                    });
                    Navigator.pop(context);

                  }else{
                    Flushbar(
                      //    title: "Sign Up Error",
                      message: 'Uploading Image Please Wait...',
                      duration: Duration(seconds: 3),
                    )..show(context);
                  }

                }),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          )),
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
    isImage=true;
    MyConstants.hideLoadingBar();
//        .then((fileURL) {
//      setState(() {
//        _uploadedFileURL = fileURL;
//      });
//    });
  }


}
