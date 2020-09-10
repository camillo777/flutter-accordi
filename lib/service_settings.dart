import 'package:shared_preferences/shared_preferences.dart';

import 'logger.dart';
import 'service_scale.dart';

class ServiceSettings {
  final log = getLogger("ServiceSettings");

  static const KEY_BPM = "bpm";
  int _iBpm = 90;
  int get getBpm => _iBpm;
  Future<void> setBpm(int bpm) async {
    _iBpm = bpm;
    await _prefs.setInt(KEY_BPM, _iBpm);
  }

  static const KEY_DISPLAY_CHORDS_BY_TYPE = "displayChordsByType";
  bool _bDisplayChordsByType = true;
  bool get getDisplayChordsByType => _bDisplayChordsByType;
  Future<void> seDisplayChordsByType(bool displayChordsByType) async {
    _bDisplayChordsByType = displayChordsByType;
    await _prefs.setBool(KEY_DISPLAY_CHORDS_BY_TYPE, _bDisplayChordsByType);
  }

  static const KEY_AUDIO_ON = "audioOn";
  bool _bAudioOn;
  bool get getAudioOn => _bAudioOn;
  Future<void> setAudioOn(bool bAudioOn) async {
    _bAudioOn = bAudioOn;
    await _prefs.setBool(KEY_AUDIO_ON, _bAudioOn);
  }

  static const KEY_NOTE_LANG = "noteLang";
  NoteLang _kNoteLang;
  NoteLang get getNoteLang => _kNoteLang;
  Future<void> setNoteLang(NoteLang noteLang) async {
    _kNoteLang = noteLang;
    await _prefs.setInt(KEY_NOTE_LANG, _kNoteLang.index);
  }

  static const KEY_NOTE_ENHARMONIC = "noteEnharmonic";
  NoteEnharmonic _kNoteEnharmonic;
  NoteEnharmonic get getNoteEnharmonic => _kNoteEnharmonic;
  Future<void> setNoteEnharmonic(NoteEnharmonic noteEnharmonic) async {
    _kNoteEnharmonic = noteEnharmonic;
    await _prefs.setInt(KEY_NOTE_ENHARMONIC, _kNoteEnharmonic.index);
  }

  SharedPreferences _prefs;

  bool _ready = false;
  get isReady => _ready;

  Future<void> loadSettings() async {
    log.i("loadSettings");

    _prefs = await SharedPreferences.getInstance();

    _iBpm = _prefs.getInt(KEY_BPM) ?? 90;
    _bDisplayChordsByType = _prefs.getBool(KEY_DISPLAY_CHORDS_BY_TYPE) ?? false;
    _bAudioOn = _prefs.getBool(KEY_AUDIO_ON) ?? true;
    _kNoteLang = NoteLang.values[_prefs.getInt(KEY_NOTE_LANG) ?? 0];
    _kNoteEnharmonic = NoteEnharmonic
        .values[_prefs.getInt(KEY_NOTE_ENHARMONIC) ?? 0];

    _ready = true;
  }
}
