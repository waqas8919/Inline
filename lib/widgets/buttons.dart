import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/tools/color_constant.dart';

//primary button
Widget primaryButton({label, trigger}) {
  return Container(
    width: 300,
    height: 56,
    child: FlatButton(
      color: myPrimaryColor,
      onPressed: trigger,
      child: Text(
        label,
        style: GoogleFonts.openSans(
            fontSize: 20, fontWeight: FontWeight.w600, color: myWhiteColor),
      ),
    ),
  );
}

Widget flatButton({label, trigger}) {
  return Container(
    margin: EdgeInsets.all(20),
    width: 300,
    height: 56,
    child: FlatButton(
      onPressed: trigger,
      color: Colors.teal,
      child: Text(
        label,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    ),
  );
}

//secondary button
Widget secondaryButton({label, trigger}) {
  return Container(
    width: 300,
    height: 56,
    child: OutlineButton(
      borderSide: BorderSide(color: myPrimaryColor, width: 2),
      highlightedBorderColor: myPrimaryColor,
      splashColor: Colors.deepOrange[100],
      color: myWhiteColor,
      onPressed: trigger,
      child: Text(
        label,
        style: GoogleFonts.openSans(
            fontSize: 20, fontWeight: FontWeight.w600, color: myPrimaryColor),
      ),
    ),
  );
}

//Icon button
Widget iconButton({icon, trigger}) {
  return Container(
    width: 45,
    height: 45,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: myBackgroundColor),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: trigger,
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.deepOrange[100],
        child: Center(
          child: Icon(
            icon,
            size: 32,
            color: myPrimaryColor,
          ),
        ),
      ),
    ),
  );
}

//liked button
class LikedButton extends StatefulWidget {
  @override
  _LikedButtonState createState() => _LikedButtonState();
}

class _LikedButtonState extends State<LikedButton> {
  bool _isFavorited = true;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: Icon(Icons.favorite,color: Colors.red[300],size: 32,)

//          IconButton(
//            icon: (),
//
//            onPressed: _toggleFavorite,
//          ),
        ),
      ],
    );
  }
}

//long add button widget
Widget addButton({icon, label, trigger}) {
  return Container(
    height: 58,
    width: double.infinity,
    decoration: BoxDecoration(
        color: myWhiteColor,
        border:
            Border.all(width: 1.0, color: myDarkGreyColor.withOpacity(0.5))),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: trigger,
        splashColor: Colors.deepOrange[100],
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 0, right: 10),
              child: Icon(icon, size: 32, color: myPrimaryColor),
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
