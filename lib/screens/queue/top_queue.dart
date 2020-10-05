import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/cards.dart';

class TopQueue extends StatefulWidget {
  @override
  _TopQueueState createState() => _TopQueueState();
}

class _TopQueueState extends State<TopQueue> {

  List<DocumentSnapshot> list=List();


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
                    'Top Queues',
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
        child: ListView.builder(
          itemCount: MyConstants.documents.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, i) {
            return  queueCards(context: context, document:MyConstants.documents[i],index: i);
          },
        )
      ),
    );
  }

  Future<void> getDocument() async {
    final QuerySnapshot result =
    await Firestore.instance.collection('Queues').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;


    setState(() {
      list.clear();
      for(int i=0;i<documents.length;i++){
        list.add(documents[i]);
      }
      MyConstants.isDocumentGot=true;
      MyConstants.documents.clear();
      MyConstants.documents.addAll(documents);
    });

  }

}
