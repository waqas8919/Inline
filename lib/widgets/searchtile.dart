import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/tools/color_constant.dart';

//search tile widget

Widget searchTile({label, trigger}) {
  return Container(
    height: 58,
    width: double.infinity,
    decoration: BoxDecoration(
      color: myWhiteColor,
      border: Border(
        bottom: BorderSide(width: 1.0, color: myDarkGreyColor.withOpacity(0.2)),
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: trigger,
        splashColor: Colors.deepOrange[100],
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: myBackgroundColor,
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(
                left: 0,
                right: 10,
              ),
              child: Icon(
                Icons.place,
                size: 28,
                color: myPrimaryColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text(label,
                  style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: myBlackColor)),
            )
          ],
        ),
      ),
    ),
  );
}
