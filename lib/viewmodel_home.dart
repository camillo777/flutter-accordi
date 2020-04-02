import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'logger.dart';
import 'service_scale.dart';

class CompoChord {

  final Chord chord;
  Chord get getChord => chord;
  //void setChord(Chord chord) => _chord = chord;

  CompoChord({
    @required this.chord
    });

}

class Compo {

  final List<CompoChord> _composition = List<CompoChord>();
  List<CompoChord> get getComposition => _composition;

  void addChord(Chord chord) => _composition.add(CompoChord(chord: chord));

}

class ViewModelHome extends ChangeNotifier {

  final log = getLogger("ViewModelScale");

  final ServiceScale _serviceScale = GetIt.I.get<ServiceScale>();

  int _currentIndex = 0;
  int get getCurrentIndex => _currentIndex;
  void setCurrentIndex(int i) { 
    _currentIndex = i; 
    notifyListeners(); 
  }

  int _selectedChord = 0;
  int get getSelectedChord => _selectedChord;
  void setSelectedChord(int index) { 
    _selectedChord = index;
    notifyListeners();
  }

  Compo _composition = Compo();
  Compo get getComposition => _composition;
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  void setIsPlaying(bool isPlaying) => _isPlaying = isPlaying;
  int _selectedCompoSlot = 0;
  int get selectedCompoSlot => _selectedCompoSlot;
  void setSelectedCompoSlot(int slot) { 
    _selectedCompoSlot = slot;
    notifyListeners();
  }
  void clearCompo() { 
    _composition.getComposition.clear();
    notifyListeners();
  }

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
    _serviceScale.makeScale();
    setSelectedChord(0);
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


  void addChordToCompo() { //Chord chord) {
    log.i("addChordToCompo");
    Chord chord = getChords[getSelectedChord];
    log.i("chord:${chord.toString()}");
      _composition.addChord(chord);
      notifyListeners();
  }
}