import 'package:flutter/material.dart';

// Colors
const blueDark = Color(0xFF1C0C5B);
const purpleDark = Color(0xFF3D2C8D);
const blueViolet = Color(0xFF3D2C8D);
const violet = Color(0xFF916BBF);
const lightViolet = Color(0xFFC996CC);
const successGreen = Color(0xFF6ECB63);
const dangerRed = Color(0xFFDC4E70);

// Text Types
TextStyle header_2 = TextStyle(
  fontWeight: FontWeight.w900,
  fontSize: 48,
  letterSpacing: 3,
);
TextStyle header_3 = TextStyle(fontWeight: FontWeight.w700, fontSize: 36);
TextStyle header_4 = TextStyle(fontWeight: FontWeight.w600, fontSize: 32);
TextStyle header_5 = TextStyle(fontWeight: FontWeight.w400, fontSize: 26);
TextStyle normalText = TextStyle(fontSize: 18);
TextStyle smallerText = TextStyle(fontSize: 14);

// Forms
const inputFormDecor = InputDecoration(
  labelStyle: TextStyle(color: blueViolet),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: blueViolet),
  ),
);
