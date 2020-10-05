import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/screens/queue/create_queue.dart';
import 'package:inline/screens/queue/inqueue.dart';
import 'package:inline/screens/queue/liked_queue.dart';
import 'package:inline/screens/queue/queues.dart';
import 'package:inline/screens/queue/updateQueue.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/buttons.dart';
import 'package:intl/intl.dart';

//full width queue card widget
Widget queueCards({BuildContext context, DocumentSnapshot document ,index}) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    child: InkWell(
      onTap: () {
        List<String> userList=List<String>();
        MyConstants.currentShowingQueue=document;
        if(document.data['visitors'].length<=0){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Queues()));
        }else{
          bool a=false;
          for(int i=0;i<document.data['visitors'].length;i++){
            userList.add(document.data['visitors'].toString());
          }
//          userList.addAll(document.data['visitors']);
          for(int i=0;i<document.data['visitors'].length;i++){
            if(MyConstants.currentShowingQueue.data['visitors'][i]==MyConstants.user.uid){
              a=true;
              break;
            }
          }
          if(a){
            Navigator.push(context, MaterialPageRoute(builder: (context) => InQueue()));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => Queues()));
          }
        }
//        Navigator.push(context, MaterialPageRoute(builder: (context) => Queues()));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: Container(
          height: 120,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: myLightColor),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: document['image']!=null? CachedNetworkImage(
                  imageUrl: document['image'],
                  placeholder: (context, url) =>Image.asset('assets/images/img-1.jpg'),
//                    errorWidget:(context, url) Image.asset('assets/images/img-1.jpg'),
                ):
              Image.asset('assets/images/img-1.jpg'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(document.data['hostName'],
                                  style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: myBlackColor)),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.yellow[400],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text('4',
                                      style: GoogleFonts.openSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: myBlackColor)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text('('+document.data['visitors'].length.toString()+' visitors)',
                                      style: GoogleFonts.openSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: myBlackColor)),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(document.data['visitorLimit'].toString()+' visitor(s) at a time',
                                  style: GoogleFonts.openSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: myPrimaryColor)),
                            ),
                          ],
                        ),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('waiting',
                                style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: myBlackColor)),
                            Text(document.data['visitors'].length.toString()+'/'+(document.data['visitorLimit']+document.data['queueLimit']).toString(),
                                style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: myPrimaryColor)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 200,
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        document.data['description'],
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: myBlackColor),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

//liked queuecard widget
Widget likedCards({BuildContext context,DocumentSnapshot document,int index,trigger}) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    child: InkWell(
      onTap: () {
        MyConstants.currentShowingQueue=document;
        MyConstants.isDocumentChanged=false;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Queues()));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: Container(
          height: 120,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: myLightColor),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child:document['image']!=null? CachedNetworkImage(
                    imageUrl: document['image'],
                    placeholder: (context, url) =>Image.asset('assets/images/img-1.jpg'),
//                    errorWidget:(context, url) Image.asset('assets/images/img-1.jpg'),
                  ):
                  Image.asset('assets/images/img-1.jpg'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 180,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text( document.data['hostName'],
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: myBlackColor)),
                          ),
                          InkWell(
                            onTap: trigger,
                            child: Container(
                              child: LikedButton(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 200,
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                       document.data['description'],
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: myBlackColor),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

//small card widget

Widget smallCard({BuildContext context,DocumentSnapshot document}) {
  return Container(
    margin: EdgeInsets.only(right: 5),
    child: InkWell(
      onTap: () {
        List<String> userList=List<String>();
        MyConstants.currentShowingQueue=document;
        if(document.data['visitors'].length<=0){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Queues()));
        }else{
          bool a=false;
          for(int i=0;i<document.data['visitors'].length;i++){
            userList.add(document.data['visitors'].toString());
          }
//          userList.addAll(document.data['visitors']);
          for(int i=0;i<document.data['visitors'].length;i++){
            if(MyConstants.currentShowingQueue.data['visitors'][i]==MyConstants.user.uid){
              a=true;
              break;
            }
          }
          if(a){
            Navigator.push(context, MaterialPageRoute(builder: (context) => InQueue()));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => Queues()));
          }
        }


      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: Container(
          width: 156,
          child: Column(
            children: <Widget>[
              Container(
                width: 156,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: myLightColor,
//                  image: DecorationImage(
//                    fit: BoxFit.cover,
//                    image: AssetImage(
//                      imagePath,
//                    ),
//                  ),
                ),
                child: document['image']==null?
                    Image.asset('assets/images/img-1.jpg', width: 156,
                      height: 120,)
                :CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                    ),
                    width: 156,
                    height: 120,
                    padding: EdgeInsets.all(15.0),
                  ),
                  imageUrl: document['image'],
                  width: 156,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(document['hostName'] ,
                            style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: myBlackColor)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text('waiting :',
                                style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: myBlackColor)),
                          ),
                          Container(
                            child: Text(document.data['visitors'].length.toString()+'/'+(document.data['visitorLimit']+document.data['queueLimit']).toString(),
                                style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: myPrimaryColor)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

//current queue card widget
Widget currentQueueCard({BuildContext context, DocumentSnapshot documentSnapshot}) {
  int timeInMillis = int.parse(documentSnapshot.documentID);
  var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm aaa');
  final String formatted = formatter.format(date);
  return Container(
    child: InkWell(
      onTap: () {
        MyConstants.currentShowingQueue=documentSnapshot;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InQueue()));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: MyConstants.height/5,
          width: MyConstants.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                width: 40,
                height: 40,
                child: Icon(
                  Icons.history,
                  size: 32,
                  color: myBlackColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20, right: 20),
                    child: Text(formatted,
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: myDarkGreyColor)),
                  ),
                  Container(
                    child: Text(documentSnapshot['hostName'],
                        style: GoogleFonts.openSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: myBlackColor)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 128,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amberAccent,
                    ),
                    child: Center(
                      child: Text('In Queue',
                          style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: myWhiteColor)),
                    ),
                  )
                ],
              ),
              Expanded(child: Container(),),
//              Column(
//                children: <Widget>[
//                  Container(
//                    margin: EdgeInsets.only(top: 15, ),
//                    child: Text('No.',
//                        style: GoogleFonts.openSans(
//                            fontSize: 20,
//                            fontWeight: FontWeight.w600,
//                            color: myBlackColor)),
//                  ),
//                  Container(
//                    child: Text('0',
//                        style: GoogleFonts.openSans(
//                            fontSize: 56,
//                            fontWeight: FontWeight.w600,
//                            color: myPrimaryColor)),
//                  )
//                ],
//              ),
              Expanded(child: Container(),),
            ],
          ),
        ),
      ),
    ),
  );
}

//complete queue card widget
Widget completeQueueCard({BuildContext context, DocumentSnapshot snapshot}) {

//  var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.documentID) * 1000);
  int timeInMillis = int.parse(snapshot.documentID);
  var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm aaa');
  final String formatted = formatter.format(date);
  return Container(
    child: GestureDetector(
      onTap: () {
        print("Clicked");
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 140,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                width: 40,
                height: 40,
                child: Icon(
                  Icons.history,
                  size: 32,
                  color: myBlackColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20, right: 20),
                    child: Text(formatted
//                        'Thursday, 14/06/2020, 14.30'
                        ,
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: myDarkGreyColor)),
                  ),
                  Container(
                    child: Text(snapshot['hostName'],
                        style: GoogleFonts.openSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: myBlackColor)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 128,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text('Completed',
                          style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: myWhiteColor)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

//created queue card widget
Widget createdQueueCard({BuildContext context, DocumentSnapshot documentSnapshot,trigger}) {
  return Container(
    height: 80,
    width: double.infinity,
    decoration: BoxDecoration(
        color: myWhiteColor,
        border:
            Border.all(width: 1.0, color: myDarkGreyColor.withOpacity(0.5))),
    child: Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text(documentSnapshot['hostName'],
                style: GoogleFonts.openSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: myBlackColor)),
          ),
          Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: ClipOval(
                  child: Material(
                    color: Colors.green[400], // button color
                    child: InkWell(
                      child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          )),
                      onTap: () {
                        MyConstants.updateQueue=documentSnapshot;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateQueue()));
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
                            Icons.delete,
                            color: Colors.white,
                          )),
                      onTap: () {
                        createAlertDialog(context,documentSnapshot.documentID,trigger);
                      },
                    ),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

createAlertDialog(BuildContext context,String id,trigger) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure to delete this queue?',
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
                  onTap: trigger,
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
            )),
          ],
        );
      });


}

deleteData(docId) async {
  await Firestore.instance
      .collection('Queues')
      .document(docId)
      .delete()
      .catchError((e) {
    print(e);
  });
  MyConstants.hideLoadingBar();
}

//notification card widget
Widget notificationCard({String image, label, sublabel}) {
  return Container(
    height: 80,
    width: double.infinity,
    decoration: BoxDecoration(
        color: myWhiteColor,
        border:
            Border.all(width: 1.0, color: myDarkGreyColor.withOpacity(0.5))),
    child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              child: ClipOval(
            child: Material(
              color: myPrimaryColor, // button color
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child:image==null? Icon(
                    Icons.feedback,
                    color: Colors.white,
                  ):CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                      ),
                    ),
                    imageUrl: image,
                    fit: BoxFit.cover,
                  ),

//                  Image.network(image,fit: BoxFit.fill,)
              ),
            ),
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text(label,
                    overflow:TextOverflow.ellipsis,
                    style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: myBlackColor)),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text(sublabel,
                    overflow:TextOverflow.ellipsis,
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54)),
              )
            ],
          )
        ],
      ),
    ),
  );
}
