
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/Firebase/ApiHandler.dart';
import 'package:inline/Firebase/firebase_auth_provider.dart';
import 'package:inline/screens/home/home.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/queue_guest.dart';
import 'package:intl/intl.dart';

class InQueue extends StatefulWidget {
  @override
  _InQueueState createState() => _InQueueState();
}

class _InQueueState extends State<InQueue> {
//  List<String> visitors=List();
  int timeInMillis;
  DateTime date;
   DateFormat formatter;
   String formatted;

   int number=1;
   int indexNumber=1;

//   int queueIndex=1;


   List<DocumentSnapshot> usersList=List<DocumentSnapshot>();
   List<DocumentSnapshot> queueUsersList=List<DocumentSnapshot>();

   bool a=false;


  @override
  void initState() {
    super.initState();

  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure to leave this queue?',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: myBlackColor)),
            actions: <Widget>[
              Container(
                  child: ClipOval(
                child: Material(
                  color: Colors.green[400], // button color
                  child: InkWell(
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        )),
                    onTap: () async{
                      MyConstants.showLoadingBar(context);
                      List<String> visitors=List<String>();
                      for(int i=0;i<MyConstants.currentShowingQueue.data['visitors'].length;i++){
                        visitors.add(MyConstants.currentShowingQueue.data['visitors'][i]);
                      }
//                      visitors.addAll(MyConstants.currentShowingQueue.data['visitors']);
                      for(int i=0;i<visitors.length;i++){
                        if(visitors[i]==MyConstants.user.uid){
                          visitors.removeAt(i);
                          break;
                        }
                      }



                      await Firestore.instance.collection('Queues').document(MyConstants.currentShowingQueue.documentID).updateData({
                        'visitors':visitors,
                      });
                      String adminFcm='';
                      for(int i=0;i<MyConstants.users.length;i++){
                        if(MyConstants.users[i].documentID==MyConstants.currentShowingQueue.data['createdBy']){
                          adminFcm=MyConstants.users[i].data['fcmToken'];
                        }
                        if(MyConstants.users[i].documentID==MyConstants.user.uid){
                          MyConstants.fcmToken=MyConstants.users[i].data['fcmToken'];

                        }
                      }
                      await MyConstants.saveNewNotificationToFirebase(
                          MyConstants.currentShowingQueue.data['hostName'],
                          MyConstants.currentShowingQueue.data['image'],
                          DateTime.now().millisecondsSinceEpoch.toString(),
                          MyConstants.user.uid,
                          'You left '+MyConstants.currentShowingQueue.data['hostName']);
                      await MyConstants.saveNewNotificationToFirebase(
                          MyConstants.currentShowingQueue.data['hostName'],
                          MyConstants.currentShowingQueue.data['image'],
                          DateTime.now().millisecondsSinceEpoch.toString(),
                          MyConstants.currentShowingQueue.data['createdBy'],
                          MyConstants.user.displayName+' left '+MyConstants.currentShowingQueue.data['hostName']);

                      await ApiHandler().sendNotification(MyConstants.currentShowingQueue.data['hostName'], 'You left '+MyConstants.currentShowingQueue.data['hostName'], MyConstants.fcmToken);
                      await ApiHandler().sendNotification(MyConstants.currentShowingQueue.data['hostName'], MyConstants.user.displayName+' left '+MyConstants.currentShowingQueue.data['hostName'], adminFcm);
                      MyConstants.isDocumentGot=false;
                      MyConstants.hideLoadingBar();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          Home()), (Route<dynamic> route) => false);



                    },
                  ),
                ),
              )),
              Container(
                  child: ClipOval(
                child: Material(
                  color: Colors.red[800], // button color
                  child: InkWell(
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        )),
                    onTap: () {},
                  ),
                ),
              )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if(!a){
      getcurrentQueue();



//      for(int i=0;i<MyConstants.currentShowingQueue.data['visitors'].length;i++){
//        setState(() {
//          visitors.add(MyConstants.currentShowingQueue.data['visitors'][i].toString());
//        });
//      }

      timeInMillis = int.parse(MyConstants.currentShowingQueue.documentID);
      date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
      formatter = DateFormat('yyyy-MM-dd hh:mm aaa');
      formatted = formatter.format(date);
      getUsers();
    }
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
                    'Inline',
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
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            formatted,
//                            'Thursday, 04/06/2020, 12:30',
                            style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: myBlackColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(maxWidth: 220),
                          child: Text(
                            MyConstants.currentShowingQueue.data['hostName'],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.openSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: myBlackColor),
                          ),
                        ),
                        Container(
                          child: Text(
                            indexNumber.toString(),
                            style: GoogleFonts.openSans(
                                fontSize: 42,
                                fontWeight: FontWeight.w600,
                                color: myPrimaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: myDarkGreyColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      'Customer(s) Queue',
                      style: GoogleFonts.openSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: myBlackColor),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 280,
                    child: Text(
                      'This place only allows for '+MyConstants.currentShowingQueue.data['visitorLimit'].toString()+
                          ' customer(s) at a time, with a max queue size of '+MyConstants.currentShowingQueue.data['queueLimit'].toString()+'. ',
                      style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: myBlackColor),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
//                    margin: EdgeInsets.symmetric(horizontal: width/30),
                    child:GridView.builder(
                      itemCount:queueUsersList.length??1,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 5),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return queueGuest(queueUsersList[index],index);
                      },
                    ),

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 280,
                    child: Text(
                      '(Estimate time : '+((indexNumber-1)*5).toString()+' Minutes)',
                      style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: myBlackColor),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 280,
                    child: Text(
                      '(You are #'+indexNumber.toString()+' of '+MyConstants.currentShowingQueue.data['visitors'].length.toString()+' in the queue.)',
                      style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: myBlackColor),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: myDarkGreyColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 280,
                    child: Text(
                      'Notice',
                      style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: myBlackColor),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 280,
                    child: Text(
                      'Leaving this queue will forfeit your spot in line.',
                      style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: myBlackColor),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: MyConstants.currentShowingQueue.data['createdBy']!=MyConstants.user.uid,
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 56,
                        child: OutlineButton(
                          borderSide: BorderSide(color: myPrimaryColor, width: 2),
                          highlightedBorderColor: myPrimaryColor,
                          splashColor: Colors.deepOrange[100],
                          color: myWhiteColor,
                          onPressed: () {
                            createAlertDialog(context);
                          },
                          child: Text(
                            "Leave Queue",
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: myPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: MyConstants.currentShowingQueue.data['createdBy']!=MyConstants.user.uid,
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 56,
                        child: FlatButton(
                          color: myPrimaryColor,
                          onPressed: () async {
                            List<String> queues= List<String>();
                            MyConstants.showLoadingBar(context);
                            bool isExist=false;
                            isExist=await FirebaseAuthProvider.checkDocumentExists('completedQueues',MyConstants.user.uid );
                            if(isExist){

                              queues.clear();
                              DocumentSnapshot data=await Firestore.instance.collection('completedQueues').document(MyConstants.user.uid).get();
                              for(int i=0;i<data.data['queues'].length;i++){
                                queues.add(data.data['queues'][i].toString());
                              }
                              bool added=false;
                              for(int i=0;i<queues.length;i++){
                                if(queues[i]==MyConstants.currentShowingQueue.documentID){
                                  added=true;
                                  break;
                                }
                              }
                              if(!added){
                                queues.add(MyConstants.currentShowingQueue.documentID);
                                await Firestore.instance.collection('completedQueues').document(MyConstants.user.uid).updateData({
                                  'queues':queues,
                                });
                              }

                            }else{
                              queues.add(MyConstants.currentShowingQueue.documentID);
                              await Firestore.instance.collection('completedQueues').document(MyConstants.user.uid).setData({
                                'queues':queues,
                              });
                            }

                            List<String> visitors=List<String>();
                            for(int i=0;i<MyConstants.currentShowingQueue.data['visitors'].length;i++){
                              visitors.add(MyConstants.currentShowingQueue.data['visitors'][i]);
                            }
                            for(int i=0;i<visitors.length;i++){
                              if(visitors[i]==MyConstants.user.uid){
                                visitors.removeAt(i);
                                break;
                              }
                            }



                            await Firestore.instance.collection('Queues').document(MyConstants.currentShowingQueue.documentID).updateData({
                              'visitors':visitors,
                            });
                            String adminFcm='';
                            for(int i=0;i<MyConstants.users.length;i++){
                              if(MyConstants.users[i].documentID==MyConstants.currentShowingQueue.data['createdBy']){
                                adminFcm=MyConstants.users[i].data['fcmToken'];
                              }
                              if(MyConstants.users[i].documentID==MyConstants.user.uid){
                                MyConstants.fcmToken=MyConstants.users[i].data['fcmToken'];

                              }
                            }
                            await MyConstants.saveNewNotificationToFirebase(
                                MyConstants.currentShowingQueue.data['hostName'],
                                MyConstants.currentShowingQueue.data['image'],
                                DateTime.now().millisecondsSinceEpoch.toString(),
                                MyConstants.user.uid,
                                'You completed '+MyConstants.currentShowingQueue.data['hostName']);
                            await MyConstants.saveNewNotificationToFirebase(
                                MyConstants.currentShowingQueue.data['hostName'],
                                MyConstants.currentShowingQueue.data['image'],
                                DateTime.now().millisecondsSinceEpoch.toString(),
                                MyConstants.currentShowingQueue.data['createdBy'],
                                MyConstants.user.displayName+' completed '+MyConstants.currentShowingQueue.data['hostName']);
                            await ApiHandler().sendNotification(MyConstants.currentShowingQueue.data['hostName'], 'You completed '+MyConstants.currentShowingQueue.data['hostName'], MyConstants.fcmToken);
                            await ApiHandler().sendNotification(MyConstants.currentShowingQueue.data['hostName'], MyConstants.user.displayName+' completed '+MyConstants.currentShowingQueue.data['hostName'], adminFcm);
                            MyConstants.isDocumentGot=false;

                            MyConstants.hideLoadingBar();
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                Home()), (Route<dynamic> route) => false);
                          },
                          child: Text(
                            "Complete Queue",
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: myWhiteColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUsers() async {
    final QuerySnapshot result =
    await Firestore.instance.collection('users').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      usersList.clear();
      usersList.addAll(documents);
      getUsersInQueue();
    });

  }

  void getUsersInQueue() {
    queueUsersList.clear();
    for(int i=0;i<MyConstants.currentShowingQueue.data['visitors'].length;i++){
      for(int j=0;j<usersList.length;j++){
        if(MyConstants.currentShowingQueue.data['visitors'][i]==usersList[j].documentID){
          setState(() {
            queueUsersList.add(usersList[j]);
          });
        }
      }
    }
    getIndex();

  }

  void getIndex() {
    for(int i=0;i<MyConstants.currentShowingQueue.data['visitors'].length;i++){
      if(MyConstants.currentShowingQueue.data['visitors'][i]==MyConstants.user.uid){
        setState(() {
          indexNumber=i+1;
          a=true;
        });
        break;
      }
    }

  }

  Future<void> getcurrentQueue() async {
    DocumentSnapshot documentSnapshot=await Firestore.instance.collection('Queues').document(MyConstants.currentShowingQueue.documentID).get();
    setState(() {
      MyConstants.currentShowingQueue=documentSnapshot;
    });
//    for(int i=0;i<MyConstants.documents.length;i++){
//      if(MyConstants.documents[i].documentID==MyConstants.currentShowingQueue.documentID){
//        setState(() {
//          queueIndex=i+1;
//        });
//        break;
//      }
//    }
  }
}
