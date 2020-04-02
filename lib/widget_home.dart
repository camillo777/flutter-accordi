import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'service_scale.dart';
import 'viewmodel_home.dart';

import 'logger.dart';

class WidgetHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WidgetHomeState();
  }
}

class _WidgetHomeState extends State<WidgetHome> {
  final log = getLogger("_WidgetHomeState");

  ByteData _sound;
  final FlutterMidi player = FlutterMidi();
  bool loaded = false;

  @override
  void initState() {
    log.i("initState");
    loadAll(context);
    super.initState();
  }

  void loadAll(BuildContext context) async {
    String asset = "assets/sounds/Piano.sf2";
    log.i("Loading asset [$asset]...");
    _sound = await DefaultAssetBundle.of(context).load(asset);
    //await player.unmute();

    log.i("Preparing player...");
    await player.prepare(sf2: _sound, name: "Piano.sf2");

    log.i("Initialization DONE");
    loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewModelHome>(
        create: (_) => ViewModelHome(),
        child: Consumer<ViewModelHome>(builder: (_, model, child) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Ottava"),
                    CustomButton(onPressed: () => model.decOctave(), text: "-"),
                    Text(model.getSelectedOctave.toString(), style: TextStyle(fontSize: 32)),
                    CustomButton(onPressed: () => model.incOctave(), text: "+"),
                  ],
                ),
                Text("Tonica"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: model.getNotes
                      .map((note) => InkWell(
                          onTap: () => model.setTonic(note),
                          child: Container(
                              padding: EdgeInsets.all(7),
                              color: model.getSelectedTonic == note
                                  ? Config.COLOR_MAIN_SEL
                                  : Config.COLOR_MAIN,
                              child: Text(note.toString(),
                                  style: TextStyle(
                                      color: model.getSelectedTonic == note
                                          ? Config.COLOR_TEXT_SEL
                                          : Config.COLOR_TEXT)))))
                      .toList(),
                ),
                Divider(
                  height: 15,
                ),
                Text("Tipo scala"),
                Wrap(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: model.getScaleTypes
                      .map((scaleType) => Padding(
                          padding: EdgeInsets.all(2),
                          child: InkWell(
                              onTap: () => model.setScaleType(scaleType),
                              child: Container(
                                  padding: EdgeInsets.all(7),
                                  color: model.getSelectedScaleType == scaleType
                                      ? Config.COLOR_MAIN_SEL
                                      : Config.COLOR_MAIN,
                                  child: Text(scaleType.toString(),
                                      style: TextStyle(
                                          color: model.getSelectedScaleType ==
                                                  scaleType
                                              ? Config.COLOR_TEXT_SEL
                                              : Config.COLOR_TEXT))))))
                      .toList(),
                ),
                Divider(
                  height: 15,
                ),
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
                                  player.playMidiNote(midi: midiNote);
                                  //}
                                },
                                child: Container(
                                    color: Config.COLOR_MAIN,
                                    padding: EdgeInsets.all(15),
                                    child: Text("${note.toString()}",
                                        style: TextStyle(
                                            color: Config.COLOR_TEXT)))))
                            .toList(),
                      )),
                Divider(
                  height: 15,
                ),
                Text("Accordi possibili nella scala"),
                Wrap(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: model.getChords
                      .map((chord) => Padding(
                          padding: EdgeInsets.all(2),
                          child: InkWell(
                              onTap: () => playChord(model, chord),
                              child: Container(
                                  padding: EdgeInsets.all(7),
                                  color: Config.COLOR_MAIN,
                                  child: Text(chord.toString(),
                                      style: TextStyle(
                                          color: Config.COLOR_TEXT))))))
                      .toList(),
                ),
              ]);
        }));
  }

  Future<void> playChord(ViewModelHome model, Chord chord) async {
    int noteDuration = (1000 / chord.notes.length).floor();

    for (int i = 0; i < chord.notes.length; i++) {
      Note n = chord.notes[i];
      log.i("play:${n.toString()}");
      int note = model.getMidiNote(n);
      player.playMidiNote(midi: note);
      await Future.delayed(Duration(milliseconds: noteDuration), () => "1");
    }
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  CustomButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: Config.COLOR_MAIN,
      child:
          Text(text, style: TextStyle(
            color: Config.COLOR_TEXT, 
            fontSize: 34,
            fontWeight: FontWeight.bold,
            )),
    );
  }
}
