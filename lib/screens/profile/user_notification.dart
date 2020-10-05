import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/cards.dart';

class UserNotification extends StatefulWidget {
  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {

  List<DocumentSnapshot> notifications=List<DocumentSnapshot>();


  @override
  void initState() {
    super.initState();
    getNotifications();
  }

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
                    'Notifications',
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
        child:  ListView.builder(
          itemCount: notifications.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, i) {
            return  Padding(
              padding: EdgeInsets.only(left: 20, right: 20,top: 5),
              child: notificationCard(
                image: notifications[i].data['image'],
                label: notifications[i].data['title'],
                sublabel: notifications[i].data['text'],
              ),
            );
          },
        )
//          ListView(
//          physics: BouncingScrollPhysics(),
//          children: <Widget>[
//            Padding(
//              padding: EdgeInsets.only(left: 20, right: 20, top: 50),
//              child: Column(
//                children: <Widget>[
//                  notificationCard(
//                    icon: Icons.add,
//                    label: 'New Notification',
//                    sublabel: 'your turn in 5 minutes',
//                  ),
//                  SizedBox(
//                    height: 20,
//                  ),
//                ],
//              ),
//            )
//          ],
//        ),
      ),
    );
  }

  Future<void> getNotifications() async {
    QuerySnapshot querySnapshot= await Firestore.instance.collection('users').document('notifications').collection(MyConstants.user.uid).getDocuments();
    notifications.clear();
    setState(() {
      notifications=querySnapshot.documents;
    });

  }
}
