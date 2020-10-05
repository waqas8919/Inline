import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/Firebase/firebase_auth_provider.dart';
import 'package:inline/Preferences/MySharedPreference.dart';
import 'package:inline/screens/authentication/login.dart';
import 'package:inline/screens/profile/user_info.dart';
import 'package:inline/screens/profile/user_notification.dart';
import 'package:inline/screens/queue/add_queue.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/profiletile.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


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
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 75,
                    height: 75,
                    child:
                    MyConstants.user.photoUrl!=null?
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                          ),
                        ),
                        imageUrl: MyConstants.user.photoUrl,
                        fit: BoxFit.cover,
                      ),
                    ):CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                        ),
                      ),
                      imageUrl: MyConstants.default_image_url,
                      fit: BoxFit.cover,
                    ),
//                    Image.network(MyConstants.default_image_url,
//                      fit: BoxFit.fill,
//                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        MyConstants.user.displayName,
                        style: GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: myBlackColor),
                      ))
                ],
              ),
            ),
          )),
          preferredSize: Size.fromHeight(120)),
      backgroundColor: myWhiteColor,
      body: SafeArea(
          child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Account Setting',
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: myBlackColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //Personal Info
                profileTile(
                    icon: Icons.account_circle,
                    label: 'Personal Information',
                    trigger: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfo()));
                    }),
                //Notifications
                profileTile(
                    icon: Icons.notifications,
                    label: 'Notifications',
                    trigger: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserNotification()));
                    }),
                //Favourite Place
                profileTile(
                    icon: Icons.add_box,
                    label: 'Create Queue',
                    trigger: () {
                      print(Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddQueue())));
                    }),
                SizedBox(
                  height: 20,
                ),
                //Logout
                Container(
                  height: 58,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: myWhiteColor,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{

                        await FirebaseAuthProvider().signOut();
                        MySharedPreferennce().userLogOut();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (Route<dynamic> route) => false);
                      },
                      splashColor: Colors.deepOrange[100],
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 0, right: 10),
                            child: Text('Log out',
                                style: GoogleFonts.nunito(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: myBlackColor)),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }

}
