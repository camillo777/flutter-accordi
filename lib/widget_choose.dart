import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'logger.dart';
import 'player.dart';
import 'service_scale.dart';
import 'viewmodel_home.dart';
import 'widget_custombutton.dart';

class WidgetChoose extends StatelessWidget {
  final log = getLogger("WidgetChoose");

  @override
  Widget build(BuildContext context) {
    ViewModelHome model = Provider.of<ViewModelHome>(context);

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
              "Scala ${model.getSelectedTonic} ${model.getSelectedScaleType.name}"),
          model.getScale == null
              ? Text("scala")
              : Container(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: model.getScale
                      .map((note) => InkWell(
                          //onTap: () => model.playMidiNote(note),
                          onTap: () {
                            int midiNote = model.getMidiNote(note);
                            log.i("midiNote:$midiNote");
                            //if (loaded){
                            log.i("ply MIDI note");
                            player.playMidiNote(midiNote);
                            //}
                          },
                          child: Container(
                              color: Config.COLOR_MAIN,
                              padding: EdgeInsets.all(15),
                              child: Text("${note.toString()}",
                                  style: TextStyle(color: Config.COLOR_TEXT)))))
                      .toList(),
                )),
          Divider(
            height: 15,
          ),
          Text("Accordi possibili nella scala"),
          Wrap(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildChords(model),
          ),
          CustomButton(onPressed: () => model.addChordToCompo(), text: "Aggiungi accordo"),
        ]);
  }

  Future<void> playChord(ViewModelHome model, Chord chord) async {
    int noteDuration = (1000 / chord.notes.length).floor();

    for (int i = 0; i < chord.notes.length; i++) {
      Note n = chord.notes[i];
      log.i("play:${n.toString()}");
      int note = model.getMidiNote(n);
      player.playMidiNote(note);
      await Future.delayed(Duration(milliseconds: noteDuration), () => "1");
    }
  }

  List<Widget> _buildChords(ViewModelHome model) {
    List<Widget> list = List<Widget>();
    for (int i = 0; i < model.getChords.length; i++) {
      Chord chord = model.getChords[i];
      list.add(_buildChord(model, chord, i));
    }
    return list;
  }

  Widget _buildChord(ViewModelHome model, Chord chord, int index) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: InkWell(
        onTap: () => playChord(model, chord),
        onLongPress: () =>
            model.setSelectedChord(index), //model.addChordToCompo(chord),
        child: Container(
          padding: EdgeInsets.all(12),
          color: model.getSelectedChord == index
              ? Config.COLOR_MAIN_SEL
              : Config.COLOR_MAIN,
          child: Text(
            chord.toString(),
            style: TextStyle(
              color: model.getSelectedChord == index
                  ? Config.COLOR_TEXT_SEL
                  : Config.COLOR_TEXT,
            ),
          ),
        ),
      ),
    );
  }
}
