import 'package:flutter/material.dart';

class Config {

  static const COLOR_TEXT = Colors.white;
  static const COLOR_TEXT_SEL = Colors.white;
  static const COLOR_TEXT_MAIN = Color.fromARGB(255, 100, 10, 255);
  static const COLOR_MAIN = Color.fromARGB(255, 100, 10, 255);
  static const COLOR_MAIN_ALT = Color.fromARGB(255, 100, 10, 155);
  static const COLOR_MAIN_SEL = Color.fromARGB(255, 255, 10, 100);
  static const COLOR_BACK = Colors.white;

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

  static const TextStyle TS_TITLE = TextStyle(
        color: Config.COLOR_TEXT_MAIN, 
        fontSize: Config.FONTSIZE_TITLE,
        fontWeight: Config.FONTWEIGHT_TITLE,
        );
  static const TextStyle TS_LABEL = TextStyle(
        color: Config.COLOR_TEXT_MAIN, 
        fontSize: Config.FONTSIZE_TEXT,
        fontWeight: Config.FONTWEIGHT_TITLE,
        );
  static const TextStyle TS_VALUE = TextStyle(
        color: Config.COLOR_TEXT_MAIN, 
        fontSize: Config.FONTSIZE_TEXT,
        );

}

class ConfigColorNote {
  final Color text;
  final Color back;
  const ConfigColorNote(this.text,this.back);

  @override
  String toString() => "${back.red}.${back.green}.${back.blue}";
}