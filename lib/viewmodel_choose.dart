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
  String toString() => "${note.id} ${color.toString()}";
}

class ViewModelChoose extends ChangeNotifier {

  final log = getLogger("ViewModelScale");

  final ServiceScale _serviceScale = GetIt.I.get<ServiceScale>();
  final ServiceSettings _serviceSettings = GetIt.I.get<ServiceSettings>();

  ViewModelChoose(){
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
      (note) => note.note.id==n.id
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
    //log.i("toggleSelectedNote | note:${n.name}");
    if (isNoteSelected(n))
      _selectedNotes.removeWhere((snote)=>snote.note.id == n.id);
    else {
      // get not used color
      ConfigColorNote ccn = _getFirstUnusedColor();
      _selectedNotes.add( SelectedNote(n, ccn) );
    }
    //log.i("_selectedNotes: ${_selectedNotes.join(",")}");
    notifyListeners();
  }
  ConfigColorNote getColorForNote(Note n) {
    //log.i("getColorForNote | note:${n.name}");
    SelectedNote sn = 
      getSelectedNotes.singleWhere((snote) => snote.note.id == n.id);
    //if (i == -1) throw Exception("Cannot find color for note ${n.toString()}");
    //log.i("getColorForNote | color:${sn.color.toString()}");
    return sn.color;
  }
  String getNoteDisplayName(String noteID) => 
    _serviceScale.getNoteDisplayName(
      noteID,
      _serviceSettings.getNoteEnharmonic,
      _serviceSettings.getNoteLang,
      );
  
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

  int get getBpm => _serviceSettings.getBpm;
  // Future<void> incBpm() async {
  //   await _serviceSettings.setBpm( _serviceSettings.getBpm+1 );
  //   notifyListeners();
  // }
  // Future<void> decBpm() async {
  //   await _serviceSettings.setBpm( _serviceSettings.getBpm-1 );
  //   notifyListeners();
  // }

  bool get getDisplayChordsByType => _serviceSettings.getDisplayChordsByType ?? false;
  Future<void> setDisplayChordsByType(bool value) async {
    await _serviceSettings.seDisplayChordsByType(value);
    notifyListeners();
  }

  bool _bShowOverlayTonicChooser = false;
  bool get getShowOverlayTonicChooser => _bShowOverlayTonicChooser;
  void setShowOverlayTonicChooser(bool val){
    _bShowOverlayTonicChooser = val;
    notifyListeners();
  }

  bool _bShowOverlayPlayNote = false;
  bool get getShowOverlayPlayNote => _bShowOverlayPlayNote;
  void setShowOverlayPlayNote(bool val){
    _bShowOverlayPlayNote = val;
    notifyListeners();
  }
  Chord _bShowOverlayPlayNoteChord;
  Chord get getShowOverlayPlayNoteChord => _bShowOverlayPlayNoteChord;
  void setShowOverlayPlayNoteChord(Chord val){
    _bShowOverlayPlayNoteChord = val;
    setShowOverlayPlayNote(true);
  }

  //final FlutterMidi player = FlutterMidi();

  //final ByteData _sound;

  //ViewModelScale(this._sound);

  // Future<void> init() async {
  //   await player.unmute();
  //   await player.prepare(sf2: _sound, name: "Piano.sf2");
  // }

  

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

  Map<int,List<int>> get getAllInversions => _serviceScale.getAllInversions;

  int get getSelectedInversion => _serviceScale.getSelectedInversion;
  void setInversion(int inv) {
    log.i("setInversion");
    _serviceScale.setSelectedInversion(inv);
    makeScale();
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
  Map<String,List<Chord>> get getChordsByNoteMap => _serviceScale.getChordsByNoteMap;
  List<ChordType> get getChordTypes => _serviceScale.getChordTypes;
  Map<String,List<ChordType>> get getChordTypesByGruppoMap => _serviceScale.getChordTypesByGruppoMap;
  
  List<ScaleType> get getScaleTypes => _serviceScale.getScaleTypes;
  List<String> get getNotes => ServiceScale.getAllNotes;


  void addChordToCompo(Chord chord) { //Chord chord) {
    log.i("addChordToCompo chord:${chord.toString()}");
    //Chord chord = getSelectedChord; //getChords[getSelectedChord];
    //log.i("chord:${chord.toString()}");
      _composition.addChord(chord);
      notifyListeners();
  }

  void findChord() => _serviceScale.findChordFromNotes();
}