import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inline/tools/color_constant.dart';

//widgets

//text input field widget
Widget primaryInputField({
  label,
  obscureText = false,
  hintText,
  formFieldKey,
  valueStatus,
  onSave,
  keyboardType,
  controllerName,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: GoogleFonts.openSans(
            fontSize: 16, fontWeight: FontWeight.w600, color: myBlackColor),
      ),
      SizedBox(
        height: 5,
      ),
      TextFormField(
        key: formFieldKey,
        validator: valueStatus,
        onSaved: onSave,
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controllerName,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: myDarkGreyColor,
              fontStyle: FontStyle.italic),
          //contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myDarkGreyColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange[200], width: 2)),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: myDarkGreyColor, width: 2),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      )
    ],
  );
}

//input field secondary
Widget secondayInputField(
    {label, sublabel, maxLines, maxLength, keyboardType, hintText,controllerText,controller,editable}) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label??' ',
          style: GoogleFonts.openSans(
              fontSize: 16, fontWeight: FontWeight.w600, color: myBlackColor),
        ),
        Text(
          sublabel ?? '',
          style: GoogleFonts.openSans(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54),
        ),
        TextFormField(
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: editable,
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            counterText: '',
            hintStyle: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: myDarkGreyColor,
            ),
            border: InputBorder.none,
          ),
        ),
        Divider(
          color: myDarkGreyColor,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}

//text area
Widget textArea({label, hintText}) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.openSans(
              fontSize: 16, fontWeight: FontWeight.w600, color: myBlackColor),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          // obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: myDarkGreyColor,
            ),
            border: InputBorder.none,
          ),
        ),
        Divider(
          color: myDarkGreyColor,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}
