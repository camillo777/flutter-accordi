import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Config {

  // static const COLOR_TEXT = Colors.white;
  // static const COLOR_TEXT_SEL = Colors.white;
  // static const COLOR_TEXT_MAIN = Color.fromARGB(255, 100, 10, 255);
  // static const COLOR_MAIN = Color.fromARGB(255, 100, 10, 255);
  // static const COLOR_MAIN_ALT = Color.fromARGB(255, 100, 10, 155);
  // static const COLOR_MAIN_SEL = Color.fromARGB(255, 255, 10, 100);
  // static const COLOR_BACK = Colors.white;

  // static const COLOR_LS = const Color.fromRGBO(0xF5, 0xF8, 0xF4, 1);
  // static const COLOR_LA = const Color.fromRGBO(0xC1, 0x9A, 0x8D, 1);
  // static const COLOR_MB = const Color.fromRGBO(0x90, 0xD5, 0xE8, 1);
  // static const COLOR_DS = const Color.fromRGBO(0xB7, 0x6D, 0x8E, 1);
  // static const COLOR_DA = const Color.fromRGBO(0x88, 0x39, 0x5A, 1);

  /*

Light shades
Use this color as the background for your dark-on-light designs, or the text color of an inverted design.

Light accent
Accent colors can be used to bring attention to design elements by contrasting with the rest of the palette.

Main brand color
This color should be eye-catching but not harsh. It can be liberally applied to your layout as its main identity.

Dark accent
Another accent color to consider. Not all colors have to be used - sometimes a simple color scheme works best.

Dark shades
Use as the text color for dark-on-light designs, or as the background for inverted designs.

  */

  static const COLOR_LS = const Color(0xFFF5F8F4);
  static const COLOR_LA = const Color(0xFFC19A8D);
  static const COLOR_MB = const Color(0xFF90D5E8);
  static const COLOR_DS = const Color(0xFFB76D8E);
  static const COLOR_DA = const Color(0xFF88395A);

  static const COLOR_BG_SEL = COLOR_DA;
  static const COLOR_BG = COLOR_DS;
  static const COLOR_TX_SEL = COLOR_LS;
  static const COLOR_TX = COLOR_LS;
  static const COLOR_INV_TX_SEL = COLOR_DS;
  static const COLOR_INV_TX = COLOR_DS;

  static const int DEFAULT_BPM = 90;

  static const FontWeight FONTWEIGHT_TITLE = FontWeight.bold;
  static const double FONTSIZE_TITLE = 16;
  static const double FONTSIZE_TEXT = 14;


static const COLOR_SELECTED_NOTES = [
ConfigColorNote(Colors.white, Colors.indigo),
ConfigColorNote(Colors.white, Colors.red),
ConfigColorNote(Colors.white, Colors.blue),
ConfigColorNote(Colors.white, Colors.green),
ConfigColorNote(Colors.white, Colors.orange),
ConfigColorNote(Colors.white, Colors.pink),
ConfigColorNote(Colors.white, Colors.brown),
ConfigColorNote(Colors.white, Colors.yellow),
ConfigColorNote(Colors.white, Colors.teal),
];

  static TextStyle TS_TITLE_DARK = GoogleFonts.nunito(
        color: Config.COLOR_LS, 
        fontSize: Config.FONTSIZE_TITLE,
        fontWeight: Config.FONTWEIGHT_TITLE,
        );
  static TextStyle TS_TITLE_LIGH = GoogleFonts.nunito(
        color: Config.COLOR_DS, 
        fontSize: Config.FONTSIZE_TITLE,
        fontWeight: Config.FONTWEIGHT_TITLE,
        );
  static TextStyle TS_LABEL_DARK = GoogleFonts.nunito(
        color: Config.COLOR_LS, 
        fontSize: Config.FONTSIZE_TEXT,
        fontWeight: Config.FONTWEIGHT_TITLE,
        );
  static TextStyle TS_LABEL_LIGH = GoogleFonts.nunito(
        color: Config.COLOR_DS, 
        fontSize: Config.FONTSIZE_TEXT,
        fontWeight: Config.FONTWEIGHT_TITLE,
        );
  static TextStyle TS_VALUE_DARK = GoogleFonts.nunito(
        color: Config.COLOR_LS, 
        fontSize: Config.FONTSIZE_TEXT,
        );
  static TextStyle TS_VALUE_LIGH = GoogleFonts.nunito(
        color: Config.COLOR_DS, 
        fontSize: Config.FONTSIZE_TEXT,
        );

  static const double RADIUS_BASE = 10;
  static const double PADDING_BASE = 15;
  static const double WIDTH_PERCENT_DIALOG = 0.9;

  // static TextStyle TS_BUTTON_DARK = GoogleFonts.nunito(
  //       color: Config.COLOR_LS, 
  //       fontSize: Config.FONTSIZE_TITLE,
  //       fontWeight: Config.FONTWEIGHT_TITLE,
  //       );
  // static TextStyle TS_BUTTON_LIGH = GoogleFonts.nunito(
  //       color: Config.COLOR_DS, 
  //       fontSize: Config.FONTSIZE_TITLE,
  //       fontWeight: Config.FONTWEIGHT_TITLE,
  //       );

}

class ConfigColorNote {
  final Color text;
  final Color back;
  const ConfigColorNote(this.text,this.back);

  @override
  String toString() => "${back.red}.${back.green}.${back.blue}";
}