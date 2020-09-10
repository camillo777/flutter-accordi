// main() {
//     Scale s = new Scale("major", 1);
// }

import 'package:flutter/material.dart';

import 'data_musictheory.dart';
import 'logger.dart';

// class Scale {
//   List<Note> _notes = List<Note>();

//   // List<BaseNote> get notes => _notes;
//   // BaseNote get first => _notes[0];
//   // int get length => _notes.length;
//   // int indexOf(String noteID) => _notes.indexWhere((note) => note.id == noteID);
//   // BaseNote getAt(int index) => _notes[index];
// }
// class BaseNotes {
//   List<BaseNote> _notes = List<BaseNote>();

//   String _lang = "en";
//   String get getLang => _lang;
//   void setLang(String lang) => _lang = lang;

//   BaseNotes() {
//     _notes.add(BaseNote("C", {
//       BaseNoteStd.en: ["C"],
//       BaseNoteStd.it: ["DO"]
//     }));
//     _notes.add(BaseNote("C#", {
//       BaseNoteStd.en: ["C#", "Db"],
//       BaseNoteStd.it: ["DO#", "REb"]
//     }));
//     _notes.add(BaseNote("D", {
//       BaseNoteStd.en: ["D"],
//       BaseNoteStd.it: ["RE"]
//     }));
//     _notes.add(BaseNote("D#", {
//       BaseNoteStd.en: ["D#", "Eb"],
//       BaseNoteStd.it: ["RE#", "MIb"]
//     }));
//     _notes.add(BaseNote("E", {
//       BaseNoteStd.en: ["E"],
//       BaseNoteStd.it: ["MI"]
//     }));
//     _notes.add(BaseNote("F", {
//       BaseNoteStd.en: ["F"],
//       BaseNoteStd.it: ["FA"]
//     }));
//     _notes.add(BaseNote("F#", {
//       BaseNoteStd.en: ["F#", "Gb"],
//       BaseNoteStd.it: ["FA#", "SOLb"]
//     }));
//     _notes.add(BaseNote("G", {
//       BaseNoteStd.en: ["G"],
//       BaseNoteStd.it: ["SOL"]
//     }));
//     _notes.add(BaseNote("G#", {
//       BaseNoteStd.en: ["G#", "Ab"],
//       BaseNoteStd.it: ["SOL#", "LAb"]
//     }));
//     _notes.add(BaseNote("A", {
//       BaseNoteStd.en: ["A"],
//       BaseNoteStd.it: ["LA"]
//     }));
//     _notes.add(BaseNote("A#", {
//       BaseNoteStd.en: ["A#", "Bb"],
//       BaseNoteStd.it: ["LA#", "SIb"]
//     }));
//     _notes.add(BaseNote("B", {
//       BaseNoteStd.en: ["B"],
//       BaseNoteStd.it: ["SI"]
//     }));
//   }

//   List<BaseNote> get notes => _notes;
//   BaseNote get first => _notes[0];
//   int get length => _notes.length;
//   int indexOf(String noteID) => _notes.indexWhere((note) => note.id == noteID);
//   BaseNote getAt(int index) => _notes[index];
// }

enum NoteLang {
  Ita,
  Eng
}


enum NoteEnharmonic {
  Diesis,
  Bemolle
}

// enum BaseNoteStd { it, en }
// class BaseNote {
//   final String id;
//   final Map<BaseNoteStd, List<String>> labels;

//   BaseNote(this.id, this.labels);

//   String getNoteName(BaseNoteStd lang, bool alt) => alt ? labels[lang][1] : labels[lang][0];
// }

class Note {
  final String id;
  //String name;
  int octave;
  String grado;

  Note(
    this.id, 
    //this.name, 
    this.octave, 
    this.grado
    );

  @override
  String toString() => "$id $octave";

  void incOctave() => octave++;
  void decOctave() => octave--;

  bool sameNote(Note n) => this.id.substring(0, 1) == n.id.substring(0, 1);

  
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
  //final String noteID;
  final Note note;
  final ChordType chordType;
  final List<Note> notes;
  final Note bass;

  Chord({
    @required this.note,
    //@required this.noteName,
    @required this.chordType,
    @required this.notes,
    @required this.bass,
  });

  @override
  String toString() => "$note $chordType" + (bass != null ? "/$bass" : "");
  String toStringExt() => "$note $chordType: " + notes.join(",");

  bool similar(Chord c) {
    if (c.notes.length != notes.length) return false;

    if (c.notes[0].id != notes[0].id) return false;

    bool different = false;
    for (int j = 0; j < notes.length; j++) {
      if (c.notes.indexWhere((note) => note.id == notes[j].id) == -1) {
        different = true;
      }
    }

    if (!different) return true;

    return false;
  }
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

  IntervalType(
      {@required this.semitoni,
      @required this.intervallo,
      @required this.name});

  factory IntervalType.fromMap(Map intervalMap) {
    return IntervalType(
      //tonica: tonica,
      name: intervalMap["nome"],
      semitoni: intervalMap["semitoni"],
      intervallo: intervalMap["intervallo"],
    );
  }
}

class ServiceScale {
  final log = getLogger("ServiceScale");

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

  Map<String, List<Chord>> get getChordsByNoteMap {
    Map<String, List<Chord>> m = Map<String, List<Chord>>();
    // create chord type name map
    getChords.forEach((ch){ 
      if (!m.containsKey(ch.note.id)) m[ch.note.id]=List<Chord>();
      m[ch.note.id].add(ch);
    });
    return m;
  }

  // final List<Note> _notes = List<Note>();
  // List<Note> get getBaseNotes => _notes;

  List<String> _notes = [
    "C",
    "C#",
    "D",
    "D#",
    "E",
    "F",
    "F#",
    "G",
    "G#",
    "A",
    "A#",
    "B"
  ];
  List<String> get getAllNotes => _notes;

  static Map<String, Map<NoteLang,String>> noteNamesLang = 
  {
    "C": {NoteLang.Eng:"C", NoteLang.Ita:"DO",},
    "C#": {NoteLang.Eng:"C#", NoteLang.Ita:"DO#",},
  "Db": {NoteLang.Eng:"Db", NoteLang.Ita:"REb",},
  "D": {NoteLang.Eng:"D", NoteLang.Ita:"RE",},
  "D#": {NoteLang.Eng:"D#", NoteLang.Ita:"RE#",},
  "Eb": {NoteLang.Eng:"Eb", NoteLang.Ita:"MIb",},
  "E": {NoteLang.Eng:"E", NoteLang.Ita:"MI",},
  "F": {NoteLang.Eng:"F", NoteLang.Ita:"FA",},
  "F#": {NoteLang.Eng:"F#", NoteLang.Ita:"FA#",},
  "Gb": {NoteLang.Eng:"Gb", NoteLang.Ita:"SOLb",},
  "G": {NoteLang.Eng:"G", NoteLang.Ita:"SOL",},
  "G#": {NoteLang.Eng:"G#", NoteLang.Ita:"SOL#",},
  "Ab": {NoteLang.Eng:"Ab", NoteLang.Ita:"LAb",},
    "A": {NoteLang.Eng:"A", NoteLang.Ita:"LA",},
  "A#": {NoteLang.Eng:"A#", NoteLang.Ita:"LA#",},
  "Bb": {NoteLang.Eng:"Bb", NoteLang.Ita:"SIb",},
  "B": {NoteLang.Eng:"B", NoteLang.Ita:"SI",},
  };

  static Map<String, Map<NoteEnharmonic,String>> noteAlt = {
  "C#": {NoteEnharmonic.Diesis:"C#",NoteEnharmonic.Bemolle:"Db"},
  "D#": {NoteEnharmonic.Diesis:"D#",NoteEnharmonic.Bemolle:"Eb"},
  "F#": {NoteEnharmonic.Diesis:"F#",NoteEnharmonic.Bemolle:"Gb"},
  "G#": {NoteEnharmonic.Diesis:"G#",NoteEnharmonic.Bemolle:"Ab"},
  "A#": {NoteEnharmonic.Diesis:"A#",NoteEnharmonic.Bemolle:"Bb"},
};


  Map<int, List<int>> listInvertion = {
    1: [0, 1, 2, 3],
    2: [1, 2, 3, 0],
    3: [2, 3, 0, 1],
    4: [3, 0, 1, 2],
  };
  Map<int, List<int>> get getAllInversions => listInvertion;

  //List triads = [1,5,8,12];

  int _selectedOctave = 1;
  int get getSelectedOctave => _selectedOctave;
  bool incOctave() {
    if (_selectedOctave == 7) return false;
    _selectedOctave++;

    for (int i = 0; i < _scale.length; i++) {
      _scale[i].incOctave();
    }

    return true;
  }

  bool decOctave() {
    if (_selectedOctave == 0) return false;
    _selectedOctave--;

    for (int i = 0; i < _scale.length; i++) {
      _scale[i].decOctave();
    }
    return true;
  }

  int _selectedInversion; // = getAllNotes[0];
  int get getSelectedInversion => _selectedInversion;
  void setSelectedInversion(inv) {
    _selectedInversion = inv;
    _selectedInversion.clamp(1, 4);
  }

  List<ScaleType> _scaleTypes = List<ScaleType>();
  List<ScaleType> get getScaleTypes => _scaleTypes;

  List<ChordType> _chordTypes = List<ChordType>();
  List<ChordType> get getChordTypes => _chordTypes;
  Map<String, List<ChordType>> get getChordTypesByGruppoMap {
    Map<String, List<ChordType>> m = Map<String, List<ChordType>>();
    // create chord type name map
    getChordTypes.forEach((ch){ 
      if (!m.containsKey(ch.gruppo)) m[ch.gruppo]=List<ChordType>();
      m[ch.gruppo].add(ch);
    });
    return m;
  }


  List<IntervalType> _intervalTypes = List<IntervalType>();
  List<IntervalType> get getIntervalTypes => _intervalTypes;

  ServiceScale() {
    log.i("ServiceScale");

    _selectedTonic = _notes.first;

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
      _intervalTypes
          .add(IntervalType.fromMap(DataMusicTheory.getAllIntervalTypes[i]));
    //_selectedChordType = _chordTypes.first;

    _selectedInversion = 1;

    //makeScale();
  }

  String getNoteDisplayName(
  String noteID, 
  NoteEnharmonic enharmonic, 
  NoteLang lang,
  ) {
  if (noteAlt.containsKey(noteID)) noteID = noteAlt[noteID][enharmonic];
  return noteNamesLang[noteID][lang];
}

  // Starting note noteID : "D#"
  // Grade interval: "3b"
  Note getNoteByInterval( String noteID, String gradoID, int octave ){

    int startIndex = _notes.indexOf(noteID);

    if (startIndex == -1) throw Exception("Tonic is wrong!");

    IntervalType it = getIntervalTypes
            .singleWhere((intervalType) => intervalType.intervallo == gradoID);

    //int octave = getSelectedOctave;
      
        int index = startIndex + it.semitoni;
        //log.i("index before: $index");
        if (index >= _notes.length) {
          int r = index % _notes.length;
          int q = ((index - r).toDouble() / _notes.length).floor();

          //index -= _notes.length;
          index = r;
          octave = getSelectedOctave + q;
        }
        //log.i("index after: $index");

        Note note = Note(
          _notes[index],
          octave,
          gradoID
        );

        return note;
  }

  Chord getChordByChordType(ChordType chordType, String noteID, int inv) {

      //ChordType chordType = getChordTypes[j];
      //log.i("Chord Type: ${chordType.toString()}");

      List<Note> notes = List<Note>();

      // // creo l'accordo
      int octave = getSelectedOctave;
      for (int h = 0; h < chordType.gradi.length; h++) {
        String gradoID = chordType.gradi[h];
      //   //log.i("Grado: $grado");

      //   IntervalType it = getIntervalTypes
      //       .singleWhere((intervalType) => intervalType.intervallo == gradoID);

      //   int index = startIndex + it.semitoni;
      //   //log.i("index before: $index");
      //   if (index >= _notes.length) {
      //     int r = index % _notes.length;
      //     int q = ((index - r).toDouble() / _notes.length).floor();

      //     //index -= _notes.length;
      //     index = r;
      //     octave = getSelectedOctave + q;
      //   }
      //   //log.i("index after: $index");

      //   Note note = Note(
      //     _notes[index],
      //     _notes[index],
      //     octave,
      //     gradoID
      //   );

      //   //log.i("note: $note");
      //   notes.add(note);

        notes.add(getNoteByInterval(noteID, gradoID, getSelectedOctave));
      }

      // genera il rivolto
      List<Note> notesInv = List<Note>();
      List<int> inversion = getAllInversions[getSelectedInversion];
      //log.i("Inversion: ${inversion.join(",")}");

      for (int i = 0; i < notes.length; i++) {
        //log.i("i:$i");
        int index;
        if (i < inversion.length)
          index = inversion[i];
        else
          index = i;
        //log.i("index:$index");

        if (index < notes.length) notesInv.add(notes[index]);
      }
      //log.i("Chord notes: ${notesInv.join(",")}");

      Chord chord = Chord(
          note: Note(noteID, octave, "1"),
          chordType: chordType,
          notes: notesInv,
          bass: notes[0].id != notesInv[0].id ? notesInv[0] : null);

    return chord;
  }


  List<Chord> _getChordTypesFor(ScaleType scaleType, String noteID) {
    List<Chord> chords = List<Chord>();

    int startIndex = _notes.indexOf(noteID);

    if (startIndex == -1) throw Exception("Tonic is wrong!");

    // for(int i=0; i<scaleType.intervalli.length; i++){

    //   if (startIndex>=scaleType.intervalli.length)
    //     startIndex-=scaleType.intervalli.length;

    for (int j = 0; j < getChordTypes.length; j++) {
      
      ChordType chordType = getChordTypes[j];
      //log.i("Chord Type: ${chordType.toString()}");

      // List<Note> notes = List<Note>();

      // // // creo l'accordo
      // int octave = getSelectedOctave;
      // for (int h = 0; h < chordType.gradi.length; h++) {

      //   String gradoID = chordType.gradi[h];
      // //   //log.i("Grado: $grado");

      // //   IntervalType it = getIntervalTypes
      // //       .singleWhere((intervalType) => intervalType.intervallo == gradoID);

      // //   int index = startIndex + it.semitoni;
      // //   //log.i("index before: $index");
      // //   if (index >= _notes.length) {
      // //     int r = index % _notes.length;
      // //     int q = ((index - r).toDouble() / _notes.length).floor();

      // //     //index -= _notes.length;
      // //     index = r;
      // //     octave = getSelectedOctave + q;
      // //   }
      // //   //log.i("index after: $index");

      // //   Note note = Note(
      // //     _notes[index],
      // //     _notes[index],
      // //     octave,
      // //     gradoID
      // //   );

      // //   //log.i("note: $note");
      // //   notes.add(note);

      //   notes.add(getNoteByInterval(noteID, gradoID, getSelectedOctave));
      // }

      // // genera il rivolto
      // List<Note> notesInv = List<Note>();
      // List<int> inversion = getAllInversions[getSelectedInversion];
      // //log.i("Inversion: ${inversion.join(",")}");

      // for (int i = 0; i < notes.length; i++) {
      //   //log.i("i:$i");
      //   int index;
      //   if (i < inversion.length)
      //     index = inversion[i];
      //   else
      //     index = i;
      //   //log.i("index:$index");

      //   if (index < notes.length) notesInv.add(notes[index]);
      // }
      // //log.i("Chord notes: ${notesInv.join(",")}");

      // Chord chord = Chord(
      //     note: Note(noteID, octave, "1"),
      //     chordType: chordType,
      //     notes: notesInv,
      //     bass: notes[0].id != notesInv[0].id ? notesInv[0] : null);

      Chord chord = getChordByChordType(chordType, noteID, 1);

      if (_chordInCurrentScale(chord)) {
        chords.add(chord);
        //log.i("chord: ${chord.toString()}");
      }
    }

    return chords;
  }

  bool _chordInCurrentScale(Chord chord) {
    for (int i = 0; i < chord.notes.length; i++) {
      Note chordNote = chord.notes[i];

      if (_scale.indexWhere((note) => note.id == chordNote.id) == -1)
        return false;
    }

    return true;
  }

  // List _chordProgs = [
  //   [1, 5, 4, 1],
  //   [1, 6, 4, 5],
  // ];

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
    //log.i("reset");
    //_scale = List<Note>();
    _scale.clear();
    _chords.clear();
    //_selectedScaleType = getAllScaleTypes.keys.first;
    //_selectedTonic = getAllNotes.first;
  }

  void makeScale() {
    //log.i("makeScale | _selectedTonic:$_selectedTonic _selectedScaleType:${_selectedScaleType.toString()}");

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
      
      String grado = scaleType.gradi[i];

      if (startNote >= getAllNotes.length) {
        startNote -= getAllNotes.length;
        octave++;
      }
      _scale.add(
        Note(
          getAllNotes[startNote],
          //getAllNotes[startNote],
          octave,
          grado
        ),
      );
      startNote += scaleType.intervalli[i];
    }
    //log.i("Scale: ${_scale.join(",")}");

    //makeScaleEnharmonic();

    // List chords = new List();
    // for(int i=1; i<=_scaleType.length; i++){
    //   chords.add(makeChord(i));
    // }
    // print(chords.toString());
    // makeChordProg(0);

    //log.i("Getting chords for scale...");
    for (int i = 0; i < _scale.length; i++) {
      Note note = _scale[i];
      _chords.addAll(
        _getChordTypesFor(scaleType, note.id),
        );
    }

    //_findChordFromNotes();
  }

  // void makeScaleEnharmonic() {
  //   if (_scale.length == 7) {
  //     bool uguali = true;
  //     while (uguali) {
  //       uguali = false;

  //       int j = 0;
  //       int i = 0;

  //       // make scale of different notes
  //       while (j < 30) {
  //         if (i >= 1) {
  //           Note prevNote = _scale[i - 1];
  //           Note thisNote = _scale[i];
  //           log.i("$prevNote == $thisNote");
  //           if (thisNote.sameNote(prevNote)) {
  //             uguali = true;
  //             if (noteAlt.containsKey(_scale[i].id)) {
  //               _scale[i].name = noteAlt[_scale[i]];
  //               break;
  //             }
  //           }
  //         }

  //         i++;
  //         j++;
  //         if (i > _scale.length) i -= _scale.length;
  //       }
  //     }
  //   }
  // }

  void findChordFromNotes() {
    log.i("_findChordFromNotes");

    List<List<String>> chordsToFind = [
      ["A", "G", "C", "E"],
      ["D", "F#", "C", "E"],
      ["D", "A", "C", "F#"],
    ];
    
    for (int nnn=0; nnn<chordsToFind.length; nnn++){

      List<String> notes = chordsToFind[nnn];

    Chord findChord = Chord(
      chordType: null,
      note: null,
      notes: [
        Note(notes[0],1,"1"), 
        Note(notes[1],1,"3"),
        Note(notes[2],1,"5"), 
        Note(notes[3],1,"7"),
      ],
      bass: null
      );

      log.i("Find chord ${findChord.notes.join(",")}");

    for(String tonic in getAllNotes) {
      //log.i("$tonic");
      setSelectedTonic(tonic);
    for(ScaleType scaleType in getScaleTypes) {

      setSelectedScaleType(scaleType);
      makeScale();

      // if (_chordInCurrentScale(findChord)){
      //   log.i("Fits in this scale: $tonic $scaleType");
      // }

    for (int i = 0; i < getChords.length; i++) {
      Chord c = getChords[i];

      if (findChord.similar(c)) log.i("Similar chord: $c $tonic$scaleType");
    }
    }
  }}}

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
