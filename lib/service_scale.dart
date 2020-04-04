// main() {
//     Scale s = new Scale("major", 1);
// }

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'data_musictheory.dart';
import 'logger.dart';

class Note {
  final String name;
  int octave;

  Note(this.name, this.octave);

  @override
  String toString() => "$name$octave";

  void incOctave() => octave++;
  void decOctave() => octave--;
}

class ChordType {
  final String gruppo;
  final String sigla;
  final String nome;
  final List<String> gradi;
  //final String tonica;

  ChordType({this.gruppo, this.gradi, this.nome, this.sigla});

  factory ChordType.fromMap(Map chordMap) {
    return ChordType(
        //tonica: tonica,
        gruppo: chordMap["gruppo"],
        gradi: chordMap["gradi"],
        nome: chordMap["nome"],
        sigla: chordMap["sigla"]);
  }

  @override
  String toString() =>
      "$sigla"; //gradi.fold("", (s,grado)=> s += grado.toString());

}

class Chord {
  Note tonic;
  ChordType chordType;
  List<Note> notes;

  Chord({
    @required this.tonic,
    @required this.chordType,
    @required this.notes,
  });

  @override
  String toString() =>
      "$tonic $chordType";
  String toStringExt() =>
      "$tonic $chordType: "+notes.join(",");


}

class ScaleType {
  final String name;
  final List<int> intervalli;
  final List<String> gradi;
  //final String tonica;

  ScaleType({this.name, this.intervalli, this.gradi});

  factory ScaleType.fromMap(Map scaleMap) {
    return ScaleType(
      //tonica: tonica,
      name: scaleMap["name"],
      intervalli: scaleMap["intervalli"],
      gradi: scaleMap["gradi"],
    );
  }

  @override
  String toString() =>
      "$name"; //gradi.fold("", (s,grado)=> s += grado.toString());

}

class IntervalType {

  final int semitoni;
  final String intervallo;
  final String name;

  IntervalType({
    @required this.semitoni, 
    @required this.intervallo, 
    @required this.name
  });

  factory IntervalType.fromMap(Map intervalMap) {
    return IntervalType(
      //tonica: tonica,
      name: intervalMap["name"],
      semitoni: intervalMap["semitoni"],
      intervallo: intervalMap["intervallo"],
    );
  }

}

class ServiceScale {
  final Logger log = getLogger("ServiceScale");

  String _selectedTonic; // = getAllNotes[0];
  String get getSelectedTonic => _selectedTonic;
  void setSelectedTonic(tonic) => _selectedTonic = tonic;

  ScaleType _selectedScaleType;
  ScaleType get getSelectedScaleType => _selectedScaleType;
  void setSelectedScaleType(scaleType) => _selectedScaleType = scaleType;

  ChordType _selectedChordType;
  ChordType get getSelectedChordType => _selectedChordType;
  void setSelectedChordType(chordType) => _selectedChordType = chordType;

  final List<Note> _scale = List<Note>();
  List<Note> get getScale => _scale;

  final List<Chord> _chords = List<Chord>();
  List<Chord> get getChords => _chords;

  List<String> _notes = [
    "c",
    "c#",
    "d",
    "d#",
    "e",
    "f",
    "f#",
    "g",
    "g#",
    "a",
    "a#",
    "b"
  ];
  List<String> get getAllNotes => _notes;

  //List triads = [1,5,8,12];

  int _selectedOctave = 1;
  int get getSelectedOctave => _selectedOctave;
  bool incOctave() {
    if (_selectedOctave==7) return false;
    _selectedOctave++;
    
    for(int i=0; i<_scale.length; i++) {
      _scale[i].incOctave();
    }

    return true;
  }
  bool decOctave() {
    if (_selectedOctave==0) return false;
    _selectedOctave--;

    for(int i=0; i<_scale.length; i++) {
      _scale[i].decOctave();
    }
    return true;
  }

  List<ScaleType> _scaleTypes = List<ScaleType>();
  List<ScaleType> get getScaleTypes => _scaleTypes;

  List<ChordType> _chordTypes = List<ChordType>();
  List<ChordType> get getChordTypes => _chordTypes;

  List<IntervalType> _intervalTypes = List<IntervalType>();
  List<IntervalType> get getIntervalTypes => _intervalTypes;

  ServiceScale() {
    log.i("ServiceScale");

    _selectedTonic = _notes[0];

    //_scaleTypes = _scaleTypesAll.map<ScaleType>((scaleType) => ScaleType.fromMap(scaleType));

    //_scaleTypes = new List<ScaleType>();
    for (int i = 0; i < DataMusicTheory.getAllScaleTypes.length; i++)
      _scaleTypes.add(ScaleType.fromMap(DataMusicTheory.getAllScaleTypes[i]));
    _selectedScaleType = _scaleTypes.first;

    //_chordTypes = _chordTypesAll.map((chordType) => ChordType.fromMap(chordType));
    //_chordTypes = new List<ChordType>();
    for (int i = 0; i < DataMusicTheory.getAllChordTypes.length; i++)
      _chordTypes.add(ChordType.fromMap(DataMusicTheory.getAllChordTypes[i]));
    _selectedChordType = _chordTypes.first;

    for (int i = 0; i < DataMusicTheory.getAllIntervalTypes.length; i++)
      _intervalTypes.add(IntervalType.fromMap(DataMusicTheory.getAllIntervalTypes[i]));
    //_selectedChordType = _chordTypes.first;

    //makeScale();
  }


  List<Chord> _getChordTypesFor(ScaleType scaleType, Note tonic) {

    List<Chord> chords = List<Chord>();

    int startIndex = _notes.indexOf(tonic.name);

    if (startIndex==-1) throw Exception("Tonic is wrong!");

    // for(int i=0; i<scaleType.intervalli.length; i++){

    //   if (startIndex>=scaleType.intervalli.length) 
    //     startIndex-=scaleType.intervalli.length;

        for(int j=0; j<getChordTypes.length; j++){

          ChordType chordType = getChordTypes[j];
          //log.i("Chord Type: ${chordType.toString()}");

          List<Note> notes = List<Note>();

          // creo l'accordo
          int octave = getSelectedOctave;
          for(int h=0; h<chordType.gradi.length; h++){
          
            String grado = chordType.gradi[h];
            //log.i("Grado: $grado");

            IntervalType it = 
              getIntervalTypes.singleWhere((intervalType)=>intervalType.intervallo==grado);

            int index = startIndex + it.semitoni;
            //log.i("index before: $index");
            if (index>=_notes.length){
              int r = index % _notes.length;
              int q = ((index-r).toDouble()/_notes.length).floor();

              //index -= _notes.length;
              index = r;
              octave = getSelectedOctave + q;
            }
            //log.i("index after: $index");

            Note note = Note(_notes[index], octave);

            //log.i("note: $note");
            notes.add(note);

          }

          Chord chord = Chord(
            tonic: tonic,
            chordType: chordType,
            notes: notes
            );
          
          if (_chordInCurrentScale(chord)){
            chords.add(chord);
            log.i("chord: ${chord.toString()}");
          }

        }

    return chords;

  }

  bool _chordInCurrentScale(Chord chord) {

    for(int i=0; i<chord.notes.length; i++){

      Note chordNote = chord.notes[i];

      if (_scale.indexWhere((note)=>note.name==chordNote.name)==-1) return false;

    }

    return true;

  }

  List _chordProgs = [
    [1, 5, 4, 1],
    [1, 6, 4, 5],
  ];

  

  // List<Chord> _getChordsInScale(ScaleType scaleType, String tonic) {
  //   List<Chord> chords = List<Chord>();



  //   for (int i = 0; i < getChordTypes.length; i++) {
  //     ChordType chordType = getChordTypes[i];

  //     bool allIn = true;

  //     // verifica se tutti i gradi sono nella scala
  //     for (int j = 0; j < chordType.gradi.length; j++) {
  //       String grado = chordType.gradi[j];

  //       if (scaleType.gradi.indexOf(grado) == -1) {
  //         allIn = false;
  //         break;
  //       }
  //     }

  //     if (allIn) {
  //       chords.add(_makeChordFromScale(scaleType, chordType, tonic));
  //     }
  //   }
  //   return chords;
  // }

  //List<int> _scaleType; // = _scaleTypes[type];

  // "note" must be: 1..12
  // void setScale(String scaleType, String tonic){
  //   log.i("setScale | scaleType:$scaleType tonic:$tonic");

  //   _selectedTonic = tonic;
  //   _selectedScaleType = scaleType;

  //   makeScale();
  // }

  // List makeChord(int i){
  //   List chord = new List();
  //     chord.add(i); //getInterval(i,i+2));
  //     chord.add(i+2); //getInterval(i+2,i+4));
  //     chord.add(i+4); //getInterval(i+4,i+6));
  //     chord.add(i+6); //getInterval(i+6,i+8));
  //     //chords.add( chord );
  //   //}
  //   // for(int c=0; c<chords.length; c++){
  //   //   List chord = chords[c];
  //   //   makeChord(chord);
  //   // }
  //   String chordString = "";
  //   for(int n=0; n<chord.length; n++){
  //     int note = chord[n];
  //     chordString += getNote(note);
  //     chordString += n < chord.length,1 ? " (" + getIntervalName(getInterval(chord[n],chord[n+1]))+") " : "";
  //   //print("${ getNote(note) } ${ getIntervalName(chords[n][0]) }");
  //   }
  //   print(chordString);
  //   return chord;
  // }

  // Chord _makeChordFromScale(
  //     ScaleType scaleType, ChordType chordType, Note tonic) {
  //   log.i("makeChordFromScale");
  //   List<Note> note = new List();
  //   // chord.add(i); //getInterval(i,i+2));
  //   // chord.add(i+2); //getInterval(i+2,i+4));
  //   // chord.add(i+4); //getInterval(i+4,i+6));
  //   // chord.add(i+6); //getInterval(i+6,i+8));
  //   //chords.add( chord );
  //   //}
  //   // for(int c=0; c<chords.length; c++){
  //   //   List chord = chords[c];
  //   //   makeChord(chord);
  //   // }
  //   //String chordString = "";
  //   for (int n = 0; n < chordType.gradi.length; n++) {
  //     String grado = chordType.gradi[n];

  //     int index = scaleType.gradi.indexOf(grado);

  //     if (index == -1)
  //       throw Exception("grado $grado non in scala ${scaleType.toString()}");

  //     Note nota = _scale[index];

  //     //if (grade>=_scale.length) grade -= _scale.length;

  //     note.add(nota);

  //     //chordString += getNote(note);
  //     //chordString += n < chord.length-1 ? " (" + getIntervalName(getInterval(chord[n],chord[n+1]))+") " : "";
  //     //print("${ getNote(note) } ${ getIntervalName(chords[n][0]) }");
  //   }
  //   log.i(note.fold<String>("", (s, note) => s += note.toString()));
  //   return Chord(chordType: chordType, notes: note, tonic: tonic);
  // }

  void reset() {
    log.i("reset");
    //_scale = List<Note>();
    _scale.clear();
    _chords.clear();
    //_selectedScaleType = getAllScaleTypes.keys.first;
    //_selectedTonic = getAllNotes.first;
  }

  void makeScale() {
    log.i(
        "makeScale | _selectedTonic:$_selectedTonic _selectedScaleType:${_selectedScaleType.toString()}");

    reset();

    int noteIndex = _notes.indexOf(_selectedTonic);
    if (noteIndex == -1) return;

    assert(noteIndex >= 0 && noteIndex < getAllNotes.length);

    //int noteIdx = noteIndex - 1;

    assert(_notes.length == 12);

    // // select scale type
    // _scaleType = _scaleTypes[scaleType];
    // assert(_scaleType.length == 7);
    // log.i(_scaleType.toString());

    // create new notes
    // List newnotes = new List();
    // for(int i=0; i<_notes.length; i++){
    //   int index = noteIndex+i;
    //   if (index >= _notes.length) index -= _notes.length;
    //   newnotes.add(_notes[index]);
    // }
    // assert(newnotes.length == 7);
    // print(newnotes.toString());

    // create new scale
    //int semis = 0;
    ScaleType scaleType = getScaleTypes
        .singleWhere((scale) => scale.name == _selectedScaleType.name);
    int startNote = getAllNotes.indexOf(_selectedTonic);
    int octave = getSelectedOctave;
    for (int i = 0; i < scaleType.intervalli.length; i++) {
      if (startNote >= getAllNotes.length) {
        startNote -= getAllNotes.length;
        octave++;
      }
      _scale.add(Note(getAllNotes[startNote], octave));
      startNote += scaleType.intervalli[i];
    }
    log.i("Scale: ${_scale.join(",")}");

    // List chords = new List();
    // for(int i=1; i<=_scaleType.length; i++){
    //   chords.add(makeChord(i));
    // }
    // print(chords.toString());
    // makeChordProg(0);

    log.i("Getting chords for scale...");
    for(int i=0; i<_scale.length; i++){
      Note note = _scale[i];
      _chords.addAll( _getChordTypesFor(scaleType, note) );
    }
    
  }

  // void makeChordProg(List<List<int>> prog){

  //   for(int n=0; n<prog.length; n++){
  //     makeChord(chordProg[n]);
  //   }
  // }

  // Nota 1..7..14
  // String getNote(int n){
  //   n -= 1; // normalize to zero
  //   int nidx = n >= _scaleType.length? n - _scaleType.length : n;
  //   return _scale[nidx];
  // }

  // params must be scale grades 1..7
  // int getInterval(int i, int j){
  //   int interval = 0;
  //   i-=1;
  //   //i >= _scaleType.length? i -= _scaleType.length : i;
  //   j-=1;
  //   //j >= _scaleType.length? j -= _scaleType.length : j;
  //   for(int n=i; n<j; n++){
  //     //print("$i $j = $n");
  //     int nidx = n >= _scaleType.length? n - _scaleType.length : n;
  //     interval += _scaleType[nidx];
  //   }
  //   //print("interval semitones: $interval = ${ getIntervalName(interval) }");
  //   return interval;
  // }

  //String getChordName(List chord) {}

  // String getIntervalName(int i) {
  //   String intName = "";
  //   switch (i) {
  //     case 4:
  //       intName = "M";
  //       break;
  //     case 3:
  //       intName = "m";
  //       break;
  //     default:
  //   }
  //   return intName;
  // }
}
