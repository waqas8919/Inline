import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/Constants/MyConstants.dart';
import 'package:inline/screens/queue/inqueue.dart';
import 'package:inline/screens/queue/queues.dart';
import 'package:inline/tools/color_constant.dart';
import 'package:inline/widgets/searchtile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {


  List<DocumentSnapshot> dummyList=List<DocumentSnapshot>();

//
//  @override
//  void initState() {
//    super.initState();
//    dummyList.clear();
//    dummyList.addAll(MyConstants.documents);
//  }

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
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: myLightColor),
                      child: Stack(
                        children: <Widget>[
                          TextField(
                            maxLengthEnforced: true,
                            onChanged: updateList,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  top: 10,
                                  bottom: 10,
                                ),
                                border: InputBorder.none,
                                hintText: 'Where are you going?...',
                                hintStyle: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: myBlueGreyColor,
                                )),
                            style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: myBlackColor),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Search()));
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  splashColor: Colors.deepOrange[600],
                                  child: Center(
                                    child: Icon(
                                      Icons.clear,
                                      color: myBlackColor,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
        preferredSize: Size.fromHeight(100),
      ),
      backgroundColor: myWhiteColor,
      body: SafeArea(
          child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                Container(
//                  child: Text(
//                    'Recent search',
//                    style: GoogleFonts.nunito(
//                        fontSize: 18,
//                        fontWeight: FontWeight.w700,
//                        color: myBlackColor),
//                  ),
//                ),
                ListView.builder(
                  itemCount: dummyList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, i) {
                    return searchTile(label: dummyList[i].data['hostName'],trigger: (){
                      List<String> userList=List<String>();
                      MyConstants.currentShowingQueue=dummyList[i];
                      if(dummyList[i].data['visitors'].length<=0){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Queues()));
                      }else{
                        bool a=false;
                        for(int j=0;j<dummyList[i].data['visitors'].length;j++){
                          userList.add(dummyList[i].data['visitors'][j].toString());
                        }
//          userList.addAll(document.data['visitors']);
                        for(int i=0;i<userList.length;i++){
                          if(userList[i]==MyConstants.user.uid){
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

                    });
                  },
                )
//                searchTile(label: 'address'),
//                searchTile(label: 'address')
              ],
            ),
          )
        ],
      )),
    );
  }

  updateList(String value){
    dummyList.clear();
    if(value==null || value.isEmpty){
      setState(() {
        dummyList.addAll(MyConstants.documents);
      });
    }
    else{
      List<DocumentSnapshot> dummyListData = List<DocumentSnapshot>();
      String s;
      if(value.length>1){
        s = '${value[0].toUpperCase()}${value.substring(1)}';
      }else{
        s = '${value[0].toUpperCase()}';
      }
      MyConstants.documents.forEach((item) {
        if(item.data['hostName'].startsWith(s)||item.data['hostName'].contains(value) || item.data['hostName'].contains(value.toUpperCase()) || item.data['hostName'].contains(value.toLowerCase())
            || item.data['hostName'].startsWith(value) || item.data['hostName'].startsWith(value.toUpperCase()) || item.data['hostName'].startsWith(value.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        dummyList.clear();
        dummyList.addAll(dummyListData);
      });
    }
  }
}
