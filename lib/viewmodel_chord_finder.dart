import 'package:accordi/logger.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:trotter/trotter.dart';

import 'service_scale.dart';
import 'service_settings.dart';

class FoundChord {
  final Chord chord;
  final List<Note> missingNotes = [];

  FoundChord(this.chord);
}

class ViewModelChordFinder extends ChangeNotifier {
  final log = getLogger("ViewModelChordFinder");

  final ServiceScale _serviceScale = GetIt.I.get<ServiceScale>();
  final ServiceSettings _serviceSettings = GetIt.I.get<ServiceSettings>();

  List<String> _selectedNotes = [];
  List<String> get getSelectedNotes => _selectedNotes;

  final List<FoundChord> _selectedChords = [];
  List<FoundChord> get getSelectedChords => _selectedChords;

  final int _iFirstFret = 0;
  final List<List<int>> _guitarNeck = [
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
  ];
  List<List<int>> get getGuitarNeck => _guitarNeck;

  void toggle(int string, int fret) {
    int oldv = _guitarNeck[string][fret];
    for (int i = 0; i < _guitarNeck[string].length; i++)
      _guitarNeck[string][i] = 0;
    if (oldv == 0) _guitarNeck[string][fret] = 1;

    _selectedNotes = getNotes();
    log.i("Note: ${_selectedNotes.join(",")}");

    // remove duplicates
    List<String> _selectedNotesDistinct = _selectedNotes.toSet().toList();

    // A chord is made of 3 or more notes
    if (_selectedNotesDistinct.length > 2) {
      _selectedChords.clear();

      //final bagOfItems = _selectedNotesDistinct;
      //final combos =
      //    Combinations(_selectedNotesDistinct.length, _selectedNotesDistinct);

      List<List<String>> combos = _getAllCombos(_selectedNotesDistinct);
      log.i("Found combos: ${combos.length} ${combos.map((e) => "$e")}");

      int i = 0;
      for (final combo in combos) {
        log.i("------------------> $i");
        getPossibleChords(combo);
        i++;
      }
/*
    getPossibleChords(_selectedNotesDistinct);

    for (int i = 1; i < _selectedNotesDistinct.length; i++) {
      // inversion
      _selectedNotesDistinct.add(_selectedNotesDistinct[0]);
      _selectedNotesDistinct.removeAt(0);
      getPossibleChords(_selectedNotesDistinct);
    }
*/

    }

    notifyListeners();
  }

  String getNoteIDFromNeck(int string, int fret) {
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

  // Recursive
  List<List<T>> getAllCombos<T>(List<T> list) {
    log.i("list: ${list.map((e) => "$e")}");
    List<List<T>> result = [];
    // head
    result.add([]);
    result.last.add(list[0]);
    if (list.length == 1) return result;
    // tail
    List<List<T>> tailCombos = getAllCombos(list.skip(1).toList());
    tailCombos.forEach((combo) {
      result.add(List.from(combo));
      combo.add(list[0]);
      result.add(List.from(combo));
    });
    log.i("result: ${result.map((e) => "$e")}");
    return result;
  }

  List<String> rol(List<String> list) {
    return List.from(list.skip(1))..add(list[0]);
  }

  List<List<String>> _getAllCombos(List<String> list) {
    print("list: ${list.map((e) => "$e")}");

    List<List<String>> result = [];
    if (list.length == 1) {
      result.add(list);
      return result;
    } else {
      for (int i = 0; i < list.length; i++) {
        List<List<String>> subList = _getAllCombos(list.skip(1).toList());
        subList.forEach((element) {
          element.insert(0, list[0]);
          result.add(element);
        });
        list = rol(list);
      }
    }

    print("results ${result.length}: ${result.map((e) => "$e")}");
    return result;
  }

  void getPossibleChords(List<String> notes) {
    log.i("getPossibleChords: ${notes.map((e) => "$e ")}");
    if (notes == null) return;
    if (notes.length == 0) return;

    //_kSelectedChords.clear();

    //for (int j = 1; j < notes.length; j++) {
    // int nextIndex =
    //     _serviceScale.getAllNotes.indexWhere((note) => note == notes[j]);
    // log.i("${_serviceScale.getAllNotes[nextIndex]}");

    List<Note> notesWithIntervals = [];

    String bass = notes[0];

    int index0 = ServiceScale.getAllNotes.indexWhere((note) => note == bass);
    //log.i("$index0 ${_serviceScale.getAllNotes[index0]}");
    //notesWithIntervals.add(Note(bass, 1, "1"));

    int diffSemitoni = 0;

    for (int i = 1; i < notes.length; i++) {
      // int nextIndex =
      //   _serviceScale.getAllNotes.indexWhere((note) => note == notes[i-1]);
      int index =
          ServiceScale.getAllNotes.indexWhere((note) => note == notes[i]);
      //log.i("$index ${_serviceScale.getAllNotes[index]}");

      //int diffSemitoni = (index - index0) % 12;
      diffSemitoni += ((index - index0) % 12);
      log.i("diffSemitoni:$diffSemitoni index0:$index0 index:$index");

      // non c'è intervallo
      if (diffSemitoni > 21) return;

      index0 = index;

      // a little fake but it works...
      //if (diffSemitoni == 1) diffSemitoni += 12; // 9b
      //if (diffSemitoni == 2) diffSemitoni += 12; // 9

      //if (diffSemitoni == 5) diffSemitoni += 12; // 11

      //if (diffSemitoni < 0) diffSemitoni += 12;

      //if (diff > 0) {
      IntervalType interval = _serviceScale.getIntervalTypes
          .firstWhere((inte) => inte.semitoni == diffSemitoni);
      log.i(
          "${notes[i]} SEMI:$diffSemitoni = ${interval.name.toString()} ${interval.intervallo}"); // ${interval.semitoni}");

      if (interval != null) {
        notesWithIntervals.add(Note(ServiceScale.getAllNotes[index], 1, interval.intervallo));
      }
      //}
      //}
    }

    if (notesWithIntervals.length == 0) return;

    //log.i("COMB. ${notesWithIntervals.map((e) => "${e.id} ${e.grado}")}");

    for (int i = 0; i < _serviceScale.getChordTypes.length; i++) {
      bool found = true;

      ChordType chordType = _serviceScale.getChordTypes[i];

      List<Note> listNotes = [];
      listNotes.add(Note(bass, 1, "1"));

      for (int j = 0; j < notesWithIntervals.length; j++) {
        Note note = notesWithIntervals[j];

        int index = chordType.gradi.indexWhere((grado) => grado == note.grado);

        if (index == -1) {
          found = false;
          continue;
        }

        listNotes.add(Note(note.id, 1, chordType.gradi[index]));
      }

      if (found) {
        log.i("Found chord: ${chordType.toString()}");

        FoundChord fc = FoundChord(
          Chord(
            chordType: chordType,
            note: Note(bass, 1, "1"),
            notes: listNotes,
            bass: null,
          ),
        );

        // find missing notes
        for (int i = 0; i < fc.chord.chordType.gradi.length; i++) {
          String gradoID = fc.chord.chordType.gradi[i];
          //log.i("$gradoID");

          int index =
              fc.chord.notes.indexWhere((note) => note.grado == gradoID);

          if (index == -1) {
            log.i("missingNotes add $gradoID");
            // missing
            fc.missingNotes
                .add(_serviceScale.getNoteByInterval(bass, gradoID, 1));
          }
        }

        _selectedChords.add(fc);
      }
    }
  }

  List<String> getNotes() {
    List<String> notes = [];

    for (int string = 0; string < 6; string++) {
      List<int> frets = _guitarNeck[string];

      for (int fret = 0; fret < frets.length; fret++) {
        int thisFret = frets[fret];

        if (thisFret == 1) {
          String noteID = getNoteIDFromNeck(string, fret);

          notes.add(noteID);
        }
      }
    }

    return List.from(notes.reversed);
  }

  String getNoteDisplayName(String noteID) => _serviceScale.getNoteDisplayName(
      noteID, _serviceSettings.getNoteEnharmonic, _serviceSettings.getNoteLang);

  // 1234
  // 2341
  // 3412
  // 4123

  // 2134
  // 1342
  // 3421
  // 4213
  //

  List<List<Note>> getListPermutated(List<Note> notes) {
    List<List<Note>> newList = [];

    // add original
    newList.add(notes);

    for (int i = 0; i < notes.length; i++) {
      for (int i = 0; i < notes.length; i++) {}
    }
  }
}
