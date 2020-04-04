import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'config.dart';
import 'logger.dart';
import 'service_scale.dart';
import 'service_settings.dart';

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

class SelectedNote {
  Note note;
  ConfigColorNote color;
  SelectedNote(this.note, this.color);

  @override
  String toString() => "${note.name} ${color.toString()}";
}

class ViewModelHome extends ChangeNotifier {

  final log = getLogger("ViewModelScale");

  final ServiceScale _serviceScale = GetIt.I.get<ServiceScale>();
  final ServiceSettings _serviceSettings = GetIt.I.get<ServiceSettings>();

  ViewModelHome(){
    makeScale();
  }

  int _currentIndex = 0;
  int get getCurrentIndex => _currentIndex;
  void setCurrentIndex(int i) { 
    _currentIndex = i; 
    notifyListeners(); 
  }

  List<SelectedNote> _selectedNotes = List<SelectedNote>();
  List<SelectedNote> get getSelectedNotes => _selectedNotes;
  bool isNoteSelected(Note n) => _selectedNotes.indexWhere(
      (note) => note.note.name==n.name
      )!=-1;
  ConfigColorNote _getFirstUnusedColor() {
    log.i("_getFirstUnusedColor");
    for(int i=0; i<Config.COLOR_SELECTED_NOTES.length; i++){
      ConfigColorNote ccn = Config.COLOR_SELECTED_NOTES[i];
      int ii = _selectedNotes.indexWhere((note)=>note.color.back == ccn.back);
      if (ii==-1) return ccn;
    }
    return Config.COLOR_SELECTED_NOTES[0];
  }
  void toggleSelectedNote(Note n) {
    log.i("toggleSelectedNote | note:${n.name}");
    if (isNoteSelected(n))
      _selectedNotes.removeWhere((snote)=>snote.note.name == n.name);
    else {
      // get not used color
      ConfigColorNote ccn = _getFirstUnusedColor();
      _selectedNotes.add( SelectedNote(n, ccn) );
    }
    log.i("_selectedNotes: ${_selectedNotes.join(",")}");
    notifyListeners();
  }
  ConfigColorNote getColorForNote(Note n) {
    //log.i("getColorForNote | note:${n.name}");
    SelectedNote sn = 
      getSelectedNotes.singleWhere((snote) => snote.note.name == n.name);
    //if (i == -1) throw Exception("Cannot find color for note ${n.toString()}");
    //log.i("getColorForNote | color:${sn.color.toString()}");
    return sn.color;
  }
  
  Chord _selectedChord;
  Chord get getSelectedChord => _selectedChord;
  //{
    //if (_selectedChord==-1) return null;
    //return getChords[ _selectedChord ];
  //}
  void setSelectedChord(Chord chord) { 
    _selectedChord = chord;
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

  int get getBpm => _serviceSettings.getBpm ?? Config.DEFAULT_BPM;
  Future<void> incBpm() async {
    await _serviceSettings.setBpm( _serviceSettings.getBpm+1 );
    notifyListeners();
  }
  Future<void> decBpm() async {
    await _serviceSettings.setBpm( _serviceSettings.getBpm-1 );
    notifyListeners();
  }

  bool get getDisplayChordsByType => _serviceSettings.getDisplayChordsByType ?? false;
  Future<void> setDisplayChordsByType(bool value) async {
    await _serviceSettings.seDisplayChordsByType(value);
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
    //if (_serviceScale.incOctave()) makeScale();
    _serviceScale.incOctave();
    notifyListeners();
  }
  void decOctave() {
    log.i("incOctave");
    //if (_serviceScale.decOctave()) makeScale();
    _serviceScale.decOctave();
    notifyListeners();
  }

  void selectAllScaleNotes() {
    log.i("selectAllScaleNotes");
    getScale.forEach((note)=>toggleSelectedNote(note));
    log.i("Selected notes: ${getSelectedNotes.join(",")}");
  }

  Future<void> makeScale() async {
    log.i("makeScale");
    _serviceScale.makeScale();
    //setSelectedChord(0);
    _selectedChord = null;
    _selectedNotes.clear();

    selectAllScaleNotes();
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


  void addChordToCompo(Chord chord) { //Chord chord) {
    log.i("addChordToCompo chord:${chord.toString()}");
    //Chord chord = getSelectedChord; //getChords[getSelectedChord];
    //log.i("chord:${chord.toString()}");
      _composition.addChord(chord);
      notifyListeners();
  }
}