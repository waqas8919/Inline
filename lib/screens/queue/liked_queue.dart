import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/cards.dart';
import 'package:inline/Constants/MyConstants.dart';

class LikedQueue extends StatefulWidget {
  @override
  _LikedQueueState createState() => _LikedQueueState();
}

class _LikedQueueState extends State<LikedQueue> {

  List<String> likedQueueIds=List<String>();
  List<DocumentSnapshot> likedQueues=List<DocumentSnapshot>();


  @override
  Widget build(BuildContext context) {
    if(!MyConstants.isDocumentChanged){
      getDocuments();
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
                    'Liked Queues',
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
          itemCount: likedQueues.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, i) {
            return  likedCards(
                context: context,
                document: likedQueues[i],
              trigger: () async {
                MyConstants.showLoadingBar(context);
                for(int i=0;i<likedQueueIds.length;i++){
                    if(likedQueueIds[i]==MyConstants.currentShowingQueue.documentID){
                      setState(() {
                        likedQueueIds.removeAt(i);
                        likedQueues.removeAt(i);
                      });
                      break;
                    }
                  }
                  await Firestore.instance.collection('liked').document(MyConstants.user.uid).updateData({
                    'queues':likedQueueIds,
                  });
                  setState(() {
                    MyConstants.isDocumentChanged=false;
                    MyConstants.isDocumentGot=false;
                    MyConstants.hideLoadingBar();
                  });

              }
            );
          },
        )


//        ListView(
//          physics: BouncingScrollPhysics(),
//          children: <Widget>[
//            Padding(
//              padding: EdgeInsets.all(20),
//              child: Column(
//                children: <Widget>[
//
//                ],
//              ),
//            )
//          ],
//        ),
      ),
    );
  }

  Future<void> getDocuments() async {
    DocumentSnapshot snapshot=await Firestore.instance.collection('liked').document(MyConstants.user.uid).get();
    setState(() {
      likedQueueIds.clear();
      for(int i=0;i<snapshot.data['queues'].length;i++){
        likedQueueIds.add(snapshot.data['queues'][i].toString());
      }

    });

    MyConstants.isDocumentChanged=true;
    getLikedQueuesData();
  }

  void getLikedQueuesData() {
    likedQueues.clear();
    for(int i=0;i<likedQueueIds.length;i++){
      for(int j=0;j<MyConstants.documents.length;j++){
        if(likedQueueIds[i]==MyConstants.documents[j].documentID){
          likedQueues.add(MyConstants.documents[j]);
        }
      }
    }

  }
}
