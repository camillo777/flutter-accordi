import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'logger.dart';
import 'service_scale.dart';

class ViewModelHome extends ChangeNotifier {

  final log = getLogger("ViewModelScale");

  final ServiceScale _serviceScale = GetIt.I.get<ServiceScale>();
  //final FlutterMidi player = FlutterMidi();

  //final ByteData _sound;

  //ViewModelScale(this._sound);

  // Future<void> init() async {
  //   await player.unmute();
  //   await player.prepare(sf2: _sound, name: "Piano.sf2");
  // }

  int getMidiNote(Note note) {
    int noteIndex = _serviceScale.getAllNotes.indexOf(note.name);
    return 36 + (12*note.octave-1) + noteIndex; // C2
  }

  //Future<void> playMidiNote(String note) async => await player.playMidiNote(midi: getMidiNote(note));

  //String _selectedTonic = ServiceScale.getAllNotes[0];
  String get getSelectedTonic => _serviceScale.getSelectedTonic;
  void setTonic(String tonic) {
    log.i("setTonic | tonic:$tonic");
    _serviceScale.setSelectedTonic( tonic );
    makeScale();
  }

  //String _selectedScaleType = ServiceScale.getAllScaleTypes.keys.first;
  ScaleType get getSelectedScaleType => _serviceScale.getSelectedScaleType;
  void setScaleType(ScaleType scaleType) {
    log.i("getSelectedScaleType | scaleType:$scaleType");
    _serviceScale.setSelectedScaleType( scaleType );
    makeScale();
  }

  int get getSelectedOctave => _serviceScale.getSelectedOctave;
  void incOctave() {
    log.i("incOctave");
    if (_serviceScale.incOctave()) makeScale();
  }
  void decOctave() {
    log.i("incOctave");
    if (_serviceScale.decOctave()) makeScale();
  }

  Future<void> makeScale() async {

    //await init();

    _serviceScale.makeScale();
    notifyListeners();    
  }

  // bool _busy = false;
  // bool get busy => _busy;
  // void setBusy(bool busy) => _busy = busy;

  // void _setScale() {
  //   //setBusy(true);
  //   _serviceScale.setScale(_selectedScaleType, _selectedTonic);
  //   notifyListeners();
  //   //setBusy(false);
  // }

  List<Note> get getScale => _serviceScale.getScale;
  List<Chord> get getChords => _serviceScale.getChords;

  List<ScaleType> get getScaleTypes => _serviceScale.getScaleTypes;
  List<String> get getNotes => _serviceScale.getAllNotes;

}