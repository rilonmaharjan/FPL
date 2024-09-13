import 'package:flutter/material.dart';

const primary = Color(0xff4eacfc);
const torquise = Color(0xff04f5ff);
const red = Color(0xffe90052);
const lightgreen = Color(0xff00ff85);
const dark = Color(0xff38003c); 
const white = Colors.white;
const black = Colors.black;
const baseColor = Color(0xff3a3a3a);
const highlightColor = Color(0xff4a4a4a);
const purple = Color(0xff681A7D);
const purple2 = Color(0xff8A3280);
const purple3 = Color(0xff240042);
const gray = Color(0xff808080); 
const gray1 = Color(0xff909090); 
const bgGrey = Color(0xffe5e5e5);
const tileGrey = Color(0xffefefef);



interBold({required double size, Color? color = const Color(0x00707070), double? charSpacing = 0.0, double? lineSpacing = 0.0, decoration}) => TextStyle(
  fontFamily: 'Inter-Bold',
  fontSize: size,
  decoration: decoration,
  color: color,
  fontWeight : FontWeight.bold,
  letterSpacing: charSpacing,       // character spacing
  height: lineSpacing               // line spacing
);

interSemiBold({required double size, Color? color = const Color(0x00707070), double? charSpacing = 0.0, double? lineSpacing = 0.0, decoration}) => TextStyle(
  fontFamily: 'Inter-SemiBold',
  fontSize: size,
  decoration: decoration,
  color: color,
  fontWeight : FontWeight.w600,
  letterSpacing: charSpacing,       // character spacing
  height: lineSpacing               // line spacing
);


interRegular({required double size, Color? color = const Color(0x00707070), double? charSpacing = 0.0, double? lineSpacing = 0.0}) => TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: size,
  color: color,
  fontWeight: FontWeight.w400,
  letterSpacing: charSpacing,       // character spacing
  height: lineSpacing               // line spacing
);

interMedium({required double size, Color? color = const Color(0x00707070), double? charSpacing = 0.0, double? lineSpacing = 0.0}) => TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: size,
  color: color,
  fontWeight: FontWeight.w500,
  letterSpacing: charSpacing,       // character spacing
  height: lineSpacing               // line spacing
);