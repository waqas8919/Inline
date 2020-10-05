import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/cards.dart';


class MyQueue extends StatefulWidget {
  @override
  _MyQueueState createState() => _MyQueueState();
}

class _MyQueueState extends State<MyQueue> {

  List <DocumentSnapshot> myList = List();
  List <DocumentSnapshot> joinedList = List();
//  List <DocumentSnapshot> currentList = List();
  List <DocumentSnapshot> completedList = List();

  @override
  Widget build(BuildContext context) {
    if(!MyConstants.isDocumentGot){
      getDocument();
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
                  Text(
                    'My Queue',
                    style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: myBlackColor),
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
                        onTap: () {
                          print("Clicked");
                        },
                        child: Icon(
                          Icons.notifications_none,
                          size: 32,
                          color: myBlackColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(100),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Current Queue',
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: myBlackColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                myList.length<=0?
                Center(child: Text('No Current Queues'),):
                ListView.builder(
                  itemCount:myList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return   currentQueueCard(context: context,documentSnapshot: myList[i]);
                  },
                ),
//                currentQueueCard(context: context,documentSnapshot: myList[0]),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    'Completed Queues',
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: myBlackColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                completedList.length<=0?
                Center(child: Text('No Completed Queues'),):
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:completedList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return   completeQueueCard(context: context,snapshot: completedList[i]);
                  },
                ),
//                Column(
//                  children: <Widget>[
//                    completeQueueCard(),
//                    completeQueueCard(),
//                    completeQueueCard(),
//                    completeQueueCard(),
//                  ],
//                )
              ],
            ),
          )
        ],
      )),
    );
  }

  Future<void> getDocument() async {
    final QuerySnapshot result =
    await Firestore.instance.collection('Queues').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    myList.clear();
    joinedList.clear();
    for(int i=0;i<documents.length;i++){
      if(documents[i].data['createdBy']==MyConstants.user.uid){
        setState(() {
          myList.add(documents[i]);
        });
      }
      if(documents[i].data['visitors'].length>0){
        for(int j=0;j<documents[i].data['visitors'].length;j++){
          if(documents[i].data['visitors'][j]==MyConstants.user.uid){
            joinedList.add(documents[i]);
          }
        }
      }

    }
    myList.addAll(joinedList);

    List<String> newList=List<String>();

    final QuerySnapshot completedResult = await Firestore.instance.collection('completedQueues').getDocuments();
    final List<DocumentSnapshot> completedDocuments = completedResult.documents;
    completedList.clear();
    for(int i=0;i<completedDocuments.length;i++){
      if(completedDocuments[i].documentID==MyConstants.user.uid){
        for(int j=0;j<completedDocuments[i].data['queues'].length;j++){
          newList.add(completedDocuments[i].data['queues'][j].toString());
        }
      }

    }

    for(int i=0;i<newList.length;i++){
      for(int j=0;j<documents.length;j++){
        if(newList[i]==documents[j].documentID){
          setState(() {
            completedList.add(documents[j]);
          });
        }
      }
    }

    for(int i=0;i<myList.length;i++){
      for(int j=0;j<completedList.length;j++){
        if(myList[i].documentID==documents[j].documentID){
          setState(() {
            myList.removeAt(i);
          });
        }
      }
    }



  }
}
