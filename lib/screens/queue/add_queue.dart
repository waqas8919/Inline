import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/screens/queue/create_queue.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/buttons.dart';
import 'package:inline/widgets/cards.dart';

class AddQueue extends StatefulWidget {
  @override
  _AddQueueState createState() => _AddQueueState();
}

class _AddQueueState extends State<AddQueue> {

  List <DocumentSnapshot> myList = List();

  @override
  Widget build(BuildContext context) {

//    if(!MyConstants.isDocumentGot){
      getDocument();
//    }

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
                    'Host a Queues',
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
              padding: EdgeInsets.only(left: 20, right: 20, top: 50),
              child: Column(
                children: <Widget>[
                  addButton(
                      icon: Icons.add,
                      label: 'Create Queue',
                      trigger: () async {
                        String received = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateQueue()));
                        if (received == null || received != null) {
                          setState(() {

                          });
                        }

                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: myDarkGreyColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  myList.length<=0?
                      Center(child: Text('No Queues Added'),):
                  ListView.builder(
                    itemCount:myList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) {
                      return   createdQueueCard(context: context,documentSnapshot: myList[i],trigger: (){
                        MyConstants.isDocumentGot=false;
                        MyConstants.showLoadingBar(context);

                        deleteData(myList[i].documentID);
                        setState(() {
                          Navigator.pop(context);
                        });
                      });
                    },
                  ),
//                  createdQueueCard(context: context, label: 'Name')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getDocument() async {
    final QuerySnapshot result =
    await Firestore.instance.collection('Queues').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    myList.clear();
    for(int i=0;i<documents.length;i++){
      if(documents[i].data['createdBy']==MyConstants.user.uid){
        setState(() {
          myList.add(documents[i]);
        });
      }
    }
    MyConstants.isDocumentGot=true;

  }

}
