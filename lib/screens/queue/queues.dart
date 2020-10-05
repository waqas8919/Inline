import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/Firebase/ApiHandler.dart';
import 'package:inline/screens/queue/inqueue.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/buttons.dart';

class Queues extends StatefulWidget {
  @override
  _QueuesState createState() => _QueuesState();
}

class _QueuesState extends State<Queues> {
  bool _isFavorited = false;
  int _favoriteCount = 10;

  List<String> visiotrs=List<String>();
  List<String> likedQueueIds=List<String>();

  bool a =false;


  @override
  void initState() {
    super.initState();
    visiotrs.clear();
    for(int i=0;i<MyConstants.currentShowingQueue.data['visitors'].length;i++){
      visiotrs.add(MyConstants.currentShowingQueue.data['visitors'][i].toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    if(!a){
      getQueues();
    }


    return Scaffold(
        appBar: PreferredSize(
          child: SafeArea(
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(color: myLightColor, boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    spreadRadius: 0.5,
                    color: Colors.grey.withOpacity(0.1),
                    offset: Offset(0, 1))
              ]),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child:
                    MyConstants.currentShowingQueue.data['image']==null?
                    Image.asset(
                      'assets/images/img-1.jpg',
                      fit: BoxFit.cover,
                    ) : CachedNetworkImage(
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                        ),
//                        padding: EdgeInsets.all(15.0),
                      ),
                      imageUrl: MyConstants.currentShowingQueue.data['image'],
                      fit: BoxFit.cover,
                    )
                    ,
                  ),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
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
                        Row(
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
                                  onTap: () {},
                                  child: Icon(
                                    Icons.share,
                                    size: 32,
                                    color: myWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              child: Material(
                                shape: CircleBorder(),
                                color: Colors.transparent,
                                child: InkWell(
                                  customBorder: CircleBorder(),
                                  splashColor: Colors.deepOrange[100],
                                  onTap: () async {
                                    String adminFcm='';
                                    for(int i=0;i<MyConstants.users.length;i++){
                                      if(MyConstants.users[i].documentID==MyConstants.currentShowingQueue.data['createdBy']){
                                        adminFcm=MyConstants.users[i].data['fcmToken'];
                                      }
                                    }

                                    if(likedQueueIds.length<=0){
                                      likedQueueIds.add(MyConstants.currentShowingQueue.documentID);
                                      _isFavorited=true;
                                      await Firestore.instance.collection('liked').document(MyConstants.user.uid).setData({
                                        'queues':likedQueueIds,
                                      });

                                      await MyConstants.saveNewNotificationToFirebase(
                                          MyConstants.currentShowingQueue.data['hostName'],
                                          MyConstants.currentShowingQueue.data['image'],
                                          DateTime.now().millisecondsSinceEpoch.toString(),
                                          MyConstants.user.uid,
                                          'You liked '+MyConstants.currentShowingQueue.data['hostName']);
                                      await MyConstants.saveNewNotificationToFirebase(
                                          MyConstants.currentShowingQueue.data['hostName'],
                                          MyConstants.currentShowingQueue.data['image'],
                                          DateTime.now().millisecondsSinceEpoch.toString(),
                                          MyConstants.currentShowingQueue.data['createdBy'],
                                          MyConstants.user.displayName+' liked '+MyConstants.currentShowingQueue.data['hostName']);
                                      await ApiHandler().sendNotification(MyConstants.currentShowingQueue.data['hostName'], 'You liked '+MyConstants.currentShowingQueue.data['hostName'], MyConstants.fcmToken);
                                      await ApiHandler().sendNotification(MyConstants.currentShowingQueue.data['hostName'], MyConstants.user.displayName+' liked '+MyConstants.currentShowingQueue.data['hostName'], adminFcm);
                                    }else{
                                      bool a=false;
                                      MyConstants.showLoadingBar(context);
                                      for(int i=0;i<likedQueueIds.length;i++){
                                        if(likedQueueIds[i]==MyConstants.currentShowingQueue.documentID){
                                          setState(() {
                                            likedQueueIds.removeAt(i);
                                            a=true;
                                            _isFavorited=false;

                                          });

                                          await MyConstants.saveNewNotificationToFirebase(
                                              MyConstants.currentShowingQueue.data['hostName'],
                                              MyConstants.currentShowingQueue.data['image'],
                                              DateTime.now().millisecondsSinceEpoch.toString(),
                                              MyConstants.user.uid,
                                              'You disliked '+MyConstants.currentShowingQueue.data['hostName']);
                                          await MyConstants.saveNewNotificationToFirebase(
                                              MyConstants.currentShowingQueue.data['hostName'],
                                              MyConstants.currentShowingQueue.data['image'],
                                              DateTime.now().millisecondsSinceEpoch.toString(),
                                              MyConstants.currentShowingQueue.data['createdBy'],
                                              MyConstants.user.displayName+' disliked '+MyConstants.currentShowingQueue.data['hostName']);
                                          await ApiHandler().sendNotification(MyConstants.currentShowingQueue.data['hostName'], 'You disliked '+MyConstants.currentShowingQueue.data['hostName'], MyConstants.fcmToken);
                                          await ApiHandler().sendNotification(MyConstants.currentShowingQueue.data['hostName'], MyConstants.user.displayName+' disliked '+MyConstants.currentShowingQueue.data['hostName'], adminFcm);
                                          break;
                                        }
                                      }
                                      if(!a){
                                        likedQueueIds.add(MyConstants.currentShowingQueue.documentID);
                                        _isFavorited=true;
                                        await MyConstants.saveNewNotificationToFirebase(
                                            MyConstants.currentShowingQueue.data['hostName'],
                                            MyConstants.currentShowingQueue.data['image'],
                                            DateTime.now().millisecondsSinceEpoch.toString(),
                                            MyConstants.user.uid,
                                            'You liked '+MyConstants.currentShowingQueue.data['hostName']);
                                        await MyConstants.saveNewNotificationToFirebase(
                                            MyConstants.currentShowingQueue.data['hostName'],
                                            MyConstants.currentShowingQueue.data['image'],
                                            DateTime.now().millisecondsSinceEpoch.toString(),
                                            MyConstants.currentShowingQueue.data['createdBy'],
                                            MyConstants.user.displayName+' liked '+MyConstants.currentShowingQueue.data['hostName']);
                                        await ApiHandler().sendNotification(MyConstants.currentShowingQueue.data['hostName'], 'You liked '+MyConstants.currentShowingQueue.data['hostName'], MyConstants.fcmToken);
                                        await ApiHandler().sendNotification(MyConstants.currentShowingQueue.data['hostName'],  MyConstants.user.displayName+' liked '+MyConstants.currentShowingQueue.data['hostName'], adminFcm);
                                      }
                                      await Firestore.instance.collection('liked').document(MyConstants.user.uid).updateData({
                                        'queues':likedQueueIds,
                                      });
                                    }

                                    setState(() {
                                      MyConstants.isDocumentChanged=false;
                                    });
                                    MyConstants.hideLoadingBar();
                                  },
                                  child: Icon(
                                    _isFavorited
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 32,
                                    color: Colors.red[300],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(200),
        ),
      backgroundColor: myWhiteColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
//          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
              Container(
                child: Text(
                  MyConstants.currentShowingQueue.data['hostName'],
                  style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: myBlackColor),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.star,
                      size: 28,
                      color: Colors.yellow[400],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text('$_favoriteCount',
                        style: GoogleFonts.openSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: myBlueGreyColor)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(MyConstants.currentShowingQueue.data['visitors'].length.toString(),
                        style: GoogleFonts.openSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: myBlueGreyColor)),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 146,
                width: double.infinity,
                child: Text(
                  MyConstants.currentShowingQueue.data['description'],
                  style: GoogleFonts.openSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: myBlackColor),
                  maxLines: 10,
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    'Customer(s) Queue :',
                    style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: myBlackColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: 280,
                  child: Text(
                    'This place only allows for '+MyConstants.currentShowingQueue.data['visitorLimit'].toString()+' customer(s) at a time, with a max queue size of '+MyConstants.currentShowingQueue.data['queueLimit'].toString()+'. ',
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: myBlackColor),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: Text(
                    'Waiting',
                    style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: myBlackColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Center(
                  child: Text(
                    visiotrs.length.toString()+'/'+(MyConstants.currentShowingQueue.data['visitorLimit']+MyConstants.currentShowingQueue.data['queueLimit']).toString(),
                    style: GoogleFonts.openSans(
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        color: myPrimaryColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: primaryButton(
                      label: 'Join Queue',
                      trigger: () async {
                        bool a=false;
                        setState(() {
                          MyConstants.showLoadingBar(context);
                        });
                        for(int i=0;i<visiotrs.length;i++){
                          if(visiotrs[i]==MyConstants.user.uid){
                            a=true;
                            break;
                          }
                        }
                        if(!a){
                          visiotrs.add(MyConstants.user.uid);
                          await Firestore.instance.collection('Queues').document(MyConstants.currentShowingQueue.documentID).updateData({
                            "visitors":visiotrs
                          });

                        }
                        DocumentSnapshot snapshot= await Firestore.instance.collection('Queues').document(MyConstants.currentShowingQueue.documentID).get();
                        String adminFcm='';
                        for(int i=0;i<MyConstants.users.length;i++){
                          if(MyConstants.users[i].documentID==snapshot.data['createdBy']){
                            adminFcm=MyConstants.users[i].data['fcmToken'];
                          }
                        }

                        await MyConstants.saveNewNotificationToFirebase(
                            snapshot.data['hostName'],
                            snapshot.data['image'],
                            DateTime.now().millisecondsSinceEpoch.toString(),
                            MyConstants.user.uid,
                            'You joined '+snapshot.data['hostName']);
                        await MyConstants.saveNewNotificationToFirebase(
                            snapshot.data['hostName'],
                            snapshot.data['image'],
                            DateTime.now().millisecondsSinceEpoch.toString(),
                            snapshot.data['createdBy'],
                            MyConstants.user.displayName+' joined '+snapshot.data['hostName']);



                        await ApiHandler().sendNotification(snapshot.data['hostName'], 'You joined '+snapshot.data['hostName'], MyConstants.fcmToken);
                        await ApiHandler().sendNotification(snapshot.data['hostName'], MyConstants.user.displayName+' joined '+snapshot.data['hostName'], adminFcm);


                        MyConstants.isDocumentGot=false;
                        a=false;
                        MyConstants.hideLoadingBar();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InQueue()));
                      })),
          ],
        ),
      )),
    );
  }

  Future<void> getQueues() async {
    DocumentSnapshot snapshot=await Firestore.instance.collection('liked').document(MyConstants.user.uid).get();
    setState(() {
      likedQueueIds.clear();
      for(int i=0;i<snapshot.data['queues'].length;i++){
        likedQueueIds.add(snapshot.data['queues'][i]);
      }

    });

    for(int i=0;i<likedQueueIds.length;i++){
      if(likedQueueIds[i]==MyConstants.currentShowingQueue.documentID){
        setState(() {
          _isFavorited=true;
        });
        break;
      }
    }
   a=true;
  }
}
