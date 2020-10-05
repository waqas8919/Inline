import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MyConstants {
  static String id = "";
  static String image_url = "http://topchoice.laszanx.com/assets/images/profile/";
  static String default_image_url = "https://firebasestorage.googleapis.com/v0/b/inline-bb242.appspot.com/o/unknown.png?alt=media&token=be3f4dba-9e20-419c-81ea-3dbfee3b5043";
  static String email = "";
  static String userName = "";
  static String phoneNumber = "";
  static String userImage = "";
  static String fcmToken = "";
  static String token = "";
  static double width = 0;
  static double height = 0;
//  static JobListResult singJob;

  static FirebaseUser user;

  static ProgressDialog pr;

  static String FCMToken='';

  static List<DocumentSnapshot> documents=List<DocumentSnapshot>();
  static List<DocumentSnapshot> users=List<DocumentSnapshot>();

  static DocumentSnapshot updateQueue;
  static DocumentSnapshot currentShowingQueue;




  static bool isDocumentGot=false;
  static bool isDocumentChanged=false;

  static final String serverKey = "key=" + "AAAAGIHkSkk:APA91bFz9S69iwqWog87QzNSum27j94s5Wo0AWxVYw1PvLebJIHCYr20N2vGS18bBJdqVJT_fhdqniJUbZpSg1D-FNqGInKuVKuilh-LE_4U3m3HP8I1hPxyQWv5lZMgpPe6RDaqbyTj";

  static List<DocumentSnapshot> notificationList=List<DocumentSnapshot>();



  static showLoadingBar(BuildContext context) {
    if (pr == null) {
      pr = new ProgressDialog(context);
      pr.style(message: 'Please wait...');
    }
    if (!pr.isShowing()) {
      pr.show();
    }
  }

  static hideLoadingBar() {
    if (pr != null && pr.isShowing()) {
      pr.hide();
    }
  }
  static Future<void> saveNewNotificationToFirebase(String title,String image,String timestamp,String userId,String text) async {
    await Firestore.instance.collection('users').document('notifications').collection(userId).document(timestamp).setData({
      'title': title,
      'image': image,
      'text': text
    });
  }




}
