import 'package:shared_preferences/shared_preferences.dart';

import 'logger.dart';

class ServiceSettings {

  final log = getLogger("ServiceSettings");

  int _bpm = 90;
  int get getBpm => _bpm;
  Future<void> setBpm(int bpm) async {
    _bpm = bpm;
    await _prefs.setInt(KEY_BPM, _bpm);
  }
  static const KEY_BPM = "bpm";

  bool _displayChordsByType = true;
  bool get getDisplayChordsByType => _displayChordsByType;
  Future<void> seDisplayChordsByType(bool displayChordsByType) async {
    _displayChordsByType = displayChordsByType;
    await _prefs.setBool(KEY_DISPLAY_CHORDS_BY_TYPE, _displayChordsByType);
  }
  static const KEY_DISPLAY_CHORDS_BY_TYPE = "displayChordsByType";

  SharedPreferences _prefs;

  bool _ready = false;
  get isReady => _ready;

  Future<void> loadSettings() async {
    log.i("loadSettings");

    _prefs = await SharedPreferences.getInstance();

    _bpm = _prefs.getInt(KEY_BPM);
    _displayChordsByType = _prefs.getBool(KEY_DISPLAY_CHORDS_BY_TYPE);

    _ready = true;

  }

}