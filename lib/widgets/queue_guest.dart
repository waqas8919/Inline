import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/tools/color_constant.dart';

Widget queueGuest(DocumentSnapshot documentSnapshot,int index) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          (index+1).toString()+'.',
          style: GoogleFonts.openSans(
              fontSize: 14, fontWeight: FontWeight.w600, color: myBlackColor),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          documentSnapshot.data['name'],
          style: GoogleFonts.openSans(
              fontSize: 14, fontWeight: FontWeight.w600, color: myBlackColor),
        ),
      ],
    ),
  );
}
