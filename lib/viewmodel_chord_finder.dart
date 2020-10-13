import 'package:accordi/logger.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'service_scale.dart';
import 'service_settings.dart';

class FoundChord {
  final Chord chord;
  final List<Note> missingNotes = List<Note>();

  FoundChord(this.chord);
}

class ViewModelChordFinder extends ChangeNotifier {

  final log = getLogger("ViewModelChordFinder");

final ServiceScale _serviceScale = GetIt.I.get<ServiceScale>();
final ServiceSettings _serviceSettings = GetIt.I.get<ServiceSettings>();

  List<String> _kSelectedNotes = List<String>();
  List<String> get getSelectedNotes => _kSelectedNotes;

  List<FoundChord> _kSelectedChords = List<FoundChord>();
  List<FoundChord> get getSelectedChords => _kSelectedChords;

  final int _iFirstFret = 0;
  final List<List<int>> _kGuitarNeck = [
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
  ];
  List<List<int>> get getGuitarNeck => _kGuitarNeck;

  void toggle(int string, int fret) {
    int oldv = _kGuitarNeck[string][fret];
    for (int i = 0; i < _kGuitarNeck[string].length; i++) _kGuitarNeck[string][i] = 0;
    if (oldv == 0) _kGuitarNeck[string][fret] = 1;

    _kSelectedNotes = getNotes();
    log.i("${_kSelectedNotes.join(",")}");

    // remove duplicates
    List<String> _kSelectedNotesDistinct = _kSelectedNotes.toSet().toList();

    _kSelectedChords.clear();

    getPossibleChords(_kSelectedNotesDistinct);

    for(int i=1; i<_kSelectedNotesDistinct.length; i++){
      // inversion
      _kSelectedNotesDistinct.add( _kSelectedNotesDistinct[0] );
      _kSelectedNotesDistinct.removeAt(0);
      getPossibleChords(_kSelectedNotesDistinct);
    }

    notifyListeners();
  }

  String getNoteID(int string, int fret) {
    int start = _iFirstFret;

    switch (string) {
      case 0:
        start += 4;
        break; // E
      case 1:
        start += 23;
        break; // A
      case 2:
        start += 19;
        break; // D
      case 3:
        start += 14;
        break; // G
      case 4:
        start += 9;
        break; // B
      case 5:
        start += 4;
        break; // E
    }

    start += fret;
    //start ++;

    //log.i("start: $start");

    if (start >= ServiceScale.getAllNotes.length)
      start = start % ServiceScale.getAllNotes.length;

    //log.i("start: $start");

    String noteID = ServiceScale.getAllNotes[start];

    return noteID;
  }

  void getPossibleChords(List<String> notes) {

    if (notes == null) return;
    if(notes.length==0) return;

    //_kSelectedChords.clear();

    //for (int j = 1; j < notes.length; j++) {
      // int nextIndex =
      //     _serviceScale.getAllNotes.indexWhere((note) => note == notes[j]);
      // log.i("${_serviceScale.getAllNotes[nextIndex]}");

      List<Note> notesWithIntervals = List<Note>();

      String bass = notes[0];

      int index0 = ServiceScale.getAllNotes.indexWhere((note) => note == bass);
      //log.i("$index0 ${_serviceScale.getAllNotes[index0]}");

      for (int i = 1; i < notes.length; i++) {

        // int nextIndex =
        //   _serviceScale.getAllNotes.indexWhere((note) => note == notes[i-1]);
        int index =
            ServiceScale.getAllNotes.indexWhere((note) => note == notes[i]);
        //log.i("$index ${_serviceScale.getAllNotes[index]}");

        int diff = index - index0;
        if(diff<0) diff += 12;
        //log.i("diff:$diff");

        //if (diff > 0) {
          IntervalType interval = _serviceScale.getIntervalTypes
              .firstWhere((inte) => inte.semitoni == diff.abs());
          log.i(
              "${interval.name.toString()} ${interval.intervallo} ${interval.semitoni}");

          if (interval!=null)
            notesWithIntervals.add(Note(
              bass,
              1,
              interval.intervallo
            ));
        //}
      //}
    }

    if (notesWithIntervals.length==0) return;


    for(int i=0; i<_serviceScale.getChordTypes.length; i++){

      bool found = true;

      ChordType chordType = _serviceScale.getChordTypes[i];

      List<Note> listNotes = List<Note>();
      listNotes.add(Note(bass, 1, "1"));

      for(int j=0; j<notesWithIntervals.length; j++){

        Note note = notesWithIntervals[j];

        int index = chordType.gradi.indexWhere((grado)=>grado==note.grado);

        if (index==-1) {
          found=false;
          continue;
        }

        listNotes.add(Note(bass, 1, chordType.gradi[index]));

      }

      if (found) {
        
        log.i("${chordType.toString()}");

        FoundChord fc = FoundChord(
          Chord(
            chordType: chordType, 
          note: Note(bass, 1, "1"), 
          notes: listNotes, 
          bass: null,
        ), );

        // find missing notes
        for(int i=0; i<fc.chord.chordType.gradi.length; i++){

          String gradoID = fc.chord.chordType.gradi[i];
          //log.i("$gradoID");

          int index = fc.chord.notes.indexWhere(
            (note) => note.grado==gradoID
          );

          if (index == -1){
            log.i("missingNotes add $gradoID");
            // missing
            fc.missingNotes.add(_serviceScale.getNoteByInterval(bass, gradoID, 1));
          }

        }

        _kSelectedChords.add( fc );

      }

    }

  }

  List<String> getNotes() {
    List<String> notes = List<String>();

    for (int string = 0; string < 6; string++) {
      List<int> frets = _kGuitarNeck[string];

      for (int fret = 0; fret < frets.length; fret++) {
        int thisFret = frets[fret];

        if (thisFret == 1) {
          String noteID = getNoteID(string, fret);

          notes.add(noteID);
        }
      }
    }

    return List.from(notes.reversed);
  }

  String getNoteDisplayName(String noteID) => 
    _serviceScale.getNoteDisplayName(noteID, _serviceSettings.getNoteEnharmonic, _serviceSettings.getNoteLang);

}