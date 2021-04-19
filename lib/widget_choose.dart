import 'package:accordi/viewmodel_settings.dart';

import 'viewmodel_audiotoggle.dart';

import 'widget_custombutton.dart';
import 'widget_big_circle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;

import 'config.dart';
import 'logger.dart';
import 'player.dart';
import 'service_scale.dart';
import 'viewmodel_choose.dart';
import 'widget_anchored_overlay.dart';

class WidgetChoose extends StatelessWidget {
  final log = getLogger("WidgetChoose");

  @override
  Widget build(BuildContext context) {
    ViewModelChoose model = Provider.of<ViewModelChoose>(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //_buildPlayingNote(context, model),

          // MyRoundButton2(
          //     onPressed: () => model.findChord(), textBold: "Find chord"),

          Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextTitle(text: "Tonica"),
                    _buildTonic(context, model),
                  ],
                ),
                //Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextTitle(text: "Ottava"),
                    _buildOttava(context, model),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextTitle(text: "Rivolto"),
                    _buildInversions(context, model),
                  ],
                ),
                //Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextTitle(text: "Scala"),
                    _buildButtonScaleType(context, model),
                  ],
                ),
              ],
            ),
          ),
          MyDivider(),
          // RaisedButton(
          //   onPressed: () {
          //     model.setShowOverlayTonicChooser(true);
          //   }),

          // RaisedButton(
          //   onPressed: () {
          //     BlinkingToast().show(
          //       context: context,
          //       externalBuilder: (BuildContext context) {
          //         return new Icon(Icons.warning, color: Colors.purple);
          //       },
          //       duration: new Duration(seconds: 5),
          //       position: new Offset(50.0, 50.0),
          //     );

          //     // showDialog(
          //     //   context: context,
          //     //   //barrierDismissible: true,
          //     //   builder: (_) => ChangeNotifierProvider.value(
          //     //     value: model,
          //     //     child: BigCircle(note: model.getNotes), //, model),
          //     //   ),
          //     // );
          //   },
          //   child: Text(model.getSelectedTonic),
          // ),
          TextTitle(
            text:
                "Scala ${model.getNoteDisplayName(model.getSelectedTonic)} ${model.getSelectedScaleType.name}",
          ),
          model.getScale == null
              ? TextValue(text: "Seleziona una tonica e il tipo di scala...")
              : _buildScale(context, model),
          MyDivider(),
          TextTitle(text: "Accordi possibili nella scala"),
          _buildChordsByTonic2(context, model),
          // Column(
          //   //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: model.getDisplayChordsByType
          //       ? _buildChordsByType(context, model)
          //       : _buildChords(context, model),
          // ),
          //MyDivider(),
          model.getShowOverlayPlayNoteChord != null
              ? _buildCurrentChord(context, model)
              : SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _buildChordDetails(Chord chord) {
    List<Widget> list = List<Widget>();

    //Chord chord =model.getSelectedChord; //model.getChords[ model.getSelectedChord ];

    //if (chord == null) return list;

    list.add(_buildChordDetailsLine("Accordo:", chord.toString(), false));
    list.add(_buildChordDetailsLine("Tipo: ", chord.chordType.nome, false));
    list.add(_buildChordDetailsLine("Gruppo:", chord.chordType.gruppo, false));
    list.add(_buildChordDetailsLine("Sigla:", chord.chordType.sigla, false));
    list.add(_buildChordDetailsLine(
        "Gradi:", chord.chordType.gradi.join(","), false));
    list.add(_buildChordDetailsLine("Note:", chord.notes.join(","), false));

    list.add(SizedBox(
        width: 100,
        height: 100,
        child: GridView.count(
            crossAxisCount: 6,
            //shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1.0,
            children: List.generate(30, (index) {
              return Center(
                  key: ObjectKey(index),
                  child: Text(
                    '$index',
                  ) //width: 100,height: 100
                  );
            }))));

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );
  }

  Widget _buildChordDetailsLine(String label, String value, bool title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        title ? TextTitle(text: "$label") : TextLabel(text: "$label"),
        title ? TextTitle(text: "$value") : TextValue(text: "$value"),
      ],
    );
  }

  void displayChord(ViewModelChoose model, Chord chord) {
    model.setShowOverlayPlayNoteChord(chord);
  }

  Future<void> playChord(ViewModelChoose model, Chord chord, bool play) async {
    log.i("playChord | chord:$chord play:$play");

    // Note is quarter note
    // 1.1 1.2 1.3 1.4
    int noteDuration = ((1000 * model.getBpm / 60) / 4).floor();
    log.i("BPM:${model.getBpm} noteDuration:$noteDuration");

    //int noteDuration = (1000 / chord.notes.length).floor();

    model.setShowOverlayPlayNoteChord(chord);

    if (!play) return;

    await Future.delayed(Duration(milliseconds: 50), () => "1");

    //List<int> invertion = model.getAllInversions[model.getSelectedInversion];

    for (int i = 0; i < chord.notes.length; i++) {
      //for (int i = 0; i < 4; i++) {

      //int index = invertion[i];

      //if (index>=chord.notes.length) index -= chord.notes.length;

      Note n = chord.notes[i]; // chord.notes[index];

      log.i("play:${n.toString()}");
      //int note = model.getMidiNote(n);
      player.playMidiNote(n);
      await Future.delayed(Duration(milliseconds: noteDuration), () => "1");
    }

    //model.setShowOverlayPlayNote(false);
  }

  Widget _buildScaleNote(ViewModelChoose model, Note note, bool selected) {
    return Column(
      children: <Widget>[
        MyRoundedEdgeText(
          //MyRoundButton2(
          textBold: "${model.getNoteDisplayName(note.id)}",
          onPressed: () {
            //int midiNote = ServiceScale.getMidiNote(note);
            //log.i("midiNote:$midiNote");
            log.i("ply MIDI note: ${note.toString()}");
            player.playMidiNote(note);
          },
        ),
        MyRoundedEdgeText(
          textNormal: "${note.grado}",
        )
      ],
    );

    // return InkWell(
    //   //onTap: () => model.playMidiNote(note),
    //   onTap: () {
    //     int midiNote = model.getMidiNote(note);
    //     log.i("midiNote:$midiNote");
    //     //if (loaded){
    //     log.i("ply MIDI note");
    //     player.playMidiNote(midiNote);
    //     //}
    //   },
    //   onLongPress: () => model.toggleSelectedNote(note),
    //   child: Container(
    //     color: selected ? model.getColorForNote(note).back : Config.COLOR_BG,
    //     padding: EdgeInsets.all(15),
    //     child: Text(
    //       "${note.toString()}",
    //       style: TextStyle(
    //           color: selected ? Config.COLOR_TX_SEL : Config.COLOR_TX),
    //     ),
    //   ),
    // );
  }

  Widget _buildScale(BuildContext context, ViewModelChoose model) {
    List<Widget> list = List<Widget>();

    bool b = true;

    for (int i = 0; i < model.getScale.length; i++) {
      Note note = model.getScale[i];

      b = !b;

      list.add(_buildScaleNote(model, note, model.isNoteSelected(note)));
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: list),
    );
  }

  List<Widget> _buildChordsByType(BuildContext context, ViewModelChoose model) {
    Map<String, List<Chord>> m = Map<String, List<Chord>>();

    // create chord type name map
    for (Chord c in model.getChords) {
      if (m[c.chordType.nome] == null) m[c.chordType.nome] = List<Chord>();
      m[c.chordType.nome].add(c);
    }

    List<Widget> l = List<Widget>();
    m.forEach((String k, List<Chord> v) {
      l.add(Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(5),
            child: TextTitle(text: k),
          ),
          Container(
              alignment: Alignment.topLeft,
              child: Wrap(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  runAlignment: WrapAlignment.start,
                  children: v
                      .map(
                        (chord) => _buildChord(
                          context,
                          model,
                          chord,
                          model.isNoteSelected(chord.note)
                              ? model.getColorForNote(chord.note).back
                              : Config.COLOR_BG,
                        ),
                        //Text(chord.toString(), style: Config.TS_VALUE)
                      )
                      .toList())),
        ],
      ));
    });

    return l;
  }

  Widget _buildChordsByTonic(BuildContext context, ViewModelChoose model) {
    final ViewModelAudioToggle modelAudioToggle =
        Provider.of<ViewModelAudioToggle>(context);

    Map<String, List<Chord>> m = Map<String, List<Chord>>();

    // create chord type name map
    for (Chord c in model.getChords) {
      if (m[c.note.id] == null) m[c.note.id] = List<Chord>();
      m[c.note.id].add(c);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: m.entries.map(
        (entry) {
          List<Widget> l = List<Widget>();
          l.add(MyRoundedEdgeText(
              textNormal: model.getNoteDisplayName(entry.key)));
          l.add(MyDivider());
          l.addAll(entry.value
              .map(
                (chord) => MyRoundedEdgeText(
                    onPressed: () =>
                        playChord(model, chord, modelAudioToggle.getAudioOn),
                    textNormal: chord.chordType.sigla),
              )
              .toList());

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: l,
          );
        },
      ).toList(),
    );
  }

  Widget _buildChords(BuildContext context, ViewModelChoose model) {
    List<Widget> list = List<Widget>();

    String prev = "";
    List<Widget> lw;
    bool b = true;
    for (int i = 0; i < model.getChords.length; i++) {
      Chord chord = model.getChords[i];

      if (!model.isNoteSelected(chord.note)) continue;

      if (prev != chord.note.id) {
        if (lw != null)
          list.add(
              //Container(
              //  color: b ? Config.COLOR_MAIN : Config.COLOR_MAIN_ALT,
              //  child:
              Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                child: TextTitle(text: model.getNoteDisplayName(prev)),
              ),
              Wrap(
                runAlignment: WrapAlignment.spaceEvenly,
                children: lw,
              )
            ],
          )

              //,)
              );
        b = !b;

        lw = List<Widget>();
        prev = chord.note.id;
      }

      lw.add(
        _buildChord(
          context,
          model,
          chord,
          model.isNoteSelected(chord.note)
              ? model.getColorForNote(chord.note).back
              : Config.COLOR_BG,
        ),
      );
    }
    if (lw != null)
      list.add(Wrap(
        children: lw,
      ));

    return Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list);
  }

  Widget _buildChord(
      BuildContext context, ViewModelChoose model, Chord chord, Color c) {
    final ViewModelAudioToggle modelAudioToggle =
        Provider.of<ViewModelAudioToggle>(context);

    return MyRoundedEdgeButton(
        //textBold: "${model.getNoteDisplayName(chord.note.id)}",
        textNormal: "${chord.chordType}" +
            (chord.bass != null
                ? " / ${model.getNoteDisplayName(chord.bass.id)}"
                : ""),
        onPressed: () => playChord(model, chord, modelAudioToggle.getAudioOn));

    // Padding(
    //   padding: EdgeInsets.all(2),
    //   child: InkWell(
    //     onTap: () => showDialog(
    //       context: context,
    //       builder: (_) => ChangeNotifierProvider.value(
    //         value: model,
    //         child: ChordInfoOverlay(chord), //, model),
    //       ),
    //     ), //playChord(model, chord),
    //     onLongPress: () =>
    //         model.setSelectedChord(chord), //model.addChordToCompo(chord),
    //     child: Container(
    //       width: MediaQuery.of(context).size.width / 3.5,
    //       padding: EdgeInsets.all(12),
    //       color: model.getSelectedChord == chord
    //           ? Config.COLOR_BG_SEL
    //           : c, //Config.COLOR_MAIN,
    //       child: Text(
    //         chord.toString(),
    //         style: TextStyle(
    //           color: model.getSelectedChord == chord
    //               ? Config.COLOR_TX_SEL
    //               : Config.COLOR_TX,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _buildInversion(
    BuildContext context,
    ViewModelChoose model, {
    String title,
    int value,
    String desc,
  }) {
    return Container(
      color: model.getSelectedInversion == value
          ? Config.COLOR_DS
          : Config.COLOR_LA,
      key: ObjectKey(value),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$title"),
            MyRoundButton2(
              onPressed: () => model.setInversion(value),
              textBold: "$value",
            ),
            Text("$desc"),
            _buildInversionSequence(value),
          ],
        ),
      ),
    );
  }

  Widget _buildInversionSequence(int value) {
    switch (value) {
      case 2:
        return Text("3 5 7 1");
        break;
      case 3:
        return Text("5 7 1 3");
        break;
      case 4:
        return Text("7 1 3 5");
        break;
    }
    return Text("1 3 5 7");
  }

  // rivolto
  Widget _buildInversions(BuildContext context, ViewModelChoose model) {
    return MyRoundedEdgeText(
      //MyRoundButton2(
      textNormal: "${model.getSelectedInversion}",
      onPressed: () => showDialog(
        context: context,
        builder: (_) => ChangeNotifierProvider.value(
          value: model,
          child: Consumer<ViewModelChoose>(
            builder: (_, model, child) => MyDialog(
              title: "Seleziona rivolto",
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                //primary: false,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: <Widget>[
                  _buildInversion(
                    context,
                    model,
                    title: "Fondamentale",
                    desc: "Fondamentale al basso",
                    value: 1,
                  ),
                  _buildInversion(
                    context,
                    model,
                    title: "Primo rivolto",
                    desc: "Terza al basso",
                    value: 2,
                  ),
                  _buildInversion(
                    context,
                    model,
                    title: "Secondo rivolto",
                    desc: "Quinta al basso",
                    value: 3,
                  ),
                  _buildInversion(
                    context,
                    model,
                    title: "Terzo rivolto",
                    desc: "Settima al basso",
                    value: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOttava(BuildContext context, ViewModelChoose model) {
    return MyRoundedEdgeText(
      //MyRoundButton2(
      textNormal: "${model.getSelectedOctave}",
      onPressed: () => showDialog(
        context: context,
        builder: (_) => ChangeNotifierProvider.value(
          value: model,
          child: Consumer<ViewModelChoose>(
            builder: (_, model, child) => MyDialog(
                title: "Seleziona ottava",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MyRoundButton2(
                      onPressed: () => model.decOctave(),
                      textBold: "-",
                      enabled: model.getSelectedOctave > 0 ? true : false,
                    ),
                    TextValueBig(text: model.getSelectedOctave.toString()),
                    MyRoundButton2(
                      onPressed: () => model.incOctave(),
                      textBold: "+",
                      enabled: model.getSelectedOctave < 7 ? true : false,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildTonic(BuildContext context, ViewModelChoose model) {
    return Consumer<ViewModelSettings>(
      builder: (_, modelSettings, child) => MyRoundedEdgeText(
        //MyRoundButton2(
        textNormal: model.getNoteDisplayName(model.getSelectedTonic),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => ChangeNotifierProvider.value(
            value: model,
            child: Consumer<ViewModelChoose>(
              builder: (_, model, child) => MyDialog(
                title: "Seleziona tonica",
                child: BigCircle(
                  notes: model.getNotes,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildFab(BuildContext context, ViewModelChoose model) {
  //   final icons = [Icons.sms, Icons.mail, Icons.phone];
  //   return AnchoredOverlay(
  //     showOverlay: model.getShowOverlayTonicChooser,
  //     overlayBuilder: (context, offset) {
  //       return CenterAbout(
  //         position: Offset(offset.dx, offset.dy - icons.length * 35.0),
  //         child: ChangeNotifierProvider<ViewModelChoose>.value(
  //           value: model,
  //           child: BigCircle(
  //             notes: model.getNotes,
  //           ),
  //         ),
  //         // FabWithIcons(
  //         //   icons: icons,
  //         //   onIconTapped: _selectedFab,
  //         // ),
  //       );
  //     },
  //     child: MyRoundButton2(
  //       textNormal: model.getSelectedTonic,
  //       onPressed: () => model.setShowOverlayTonicChooser(true),
  //       //tooltip: 'Increment',
  //       //child: Text() //Icon(Icons.add),
  //       //elevation: 2.0,
  //     ),
  //   );
  // }

  Widget _buildCurrentChord(BuildContext context, ViewModelChoose model) {
    Chord chord = model.getShowOverlayPlayNoteChord;
    log.i("_buildCurrentChord | chord:$chord");

    return Center(
      child: Padding(
        padding: EdgeInsets.all(Config.PADDING_BASE),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(Config.RADIUS_BASE),
          ),
          child: Container(
            width:
                MediaQuery.of(context).size.width * Config.WIDTH_PERCENT_DIALOG,
            decoration: BoxDecoration(
              color: Config.COLOR_LA,
              shape: BoxShape.rectangle,
              borderRadius:
                  BorderRadius.all(Radius.circular(Config.RADIUS_BASE)),
            ),
            padding: EdgeInsets.all(5), //Config.PADDING_BASE),
            //color: Config.COLOR_LA,
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Container(
                //   alignment: Alignment.topRight,
                //   child:
                //       // MyButtonCloseWindow(
                //       //   onPressed: () => model.setShowOverlayPlayNote(false),
                //       // ),
                //       MyRoundButton2(
                //     onPressed: () =>
                //         model.setShowOverlayPlayNote(false),
                //     textBold: "X",
                //   ),
                // ),
                // MyDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    MyRoundedEdgeText(
                      textBold: model.getNoteDisplayName(chord.note.id),
                      textNormal: chord.chordType.sigla,
                    ),
                    MyRoundedEdgeText(
                      textNormal: chord.chordType.nome,
                    ),
                    MyRoundedEdgeText(
                      textNormal: chord.chordType.gruppo,
                    ),
                  ],
                ),
                // MyRoundedEdgeText(
                //   textBold: model.getNoteDisplayName(chord.note.name),
                //   textNormal: chord.chordType.sigla,
                // ),
                MyDivider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: model.getShowOverlayPlayNoteChord.notes
                        .map(
                          (note) => Column(
                            children: <Widget>[
                              MyRoundedEdgeText(
                                textBold: model.getNoteDisplayName(note.id),
                                textNormal: "${note.octave}",
                              ),
                              MyRoundedEdgeText(
                                textNormal: "${note.grado}",
                              )
                            ],
                          ),
                        )
                        .toList()),
                //_buildChordDetails(chord),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayingNote(BuildContext context, ViewModelChoose model) {
    //log.i("_buildPlayingNote val:${model.getShowOverlayPlayNoteValue} ${model.getShowOverlayPlayNote}");
    return OverlayBuilder(
      showOverlay: model.getShowOverlayPlayNote,
      overlayBuilder: (context) =>
          ChangeNotifierProvider<ViewModelChoose>.value(
        value: model,
        child: Consumer<ViewModelChoose>(builder: (_, model, child) {
          Chord chord = model.getShowOverlayPlayNoteChord;

          return Material(
            color: Colors.transparent,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(Config.PADDING_BASE),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Config.RADIUS_BASE),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        Config.WIDTH_PERCENT_DIALOG,
                    decoration: BoxDecoration(
                      color: Config.COLOR_LA,
                      shape: BoxShape.rectangle,
                      borderRadius:
                          BorderRadius.all(Radius.circular(Config.RADIUS_BASE)),
                    ),
                    padding: EdgeInsets.all(Config.PADDING_BASE),
                    //color: Config.COLOR_LA,
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: <Widget>[
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topRight,
                          child:
                              // MyButtonCloseWindow(
                              //   onPressed: () => model.setShowOverlayPlayNote(false),
                              // ),
                              MyRoundButton2(
                            onPressed: () =>
                                model.setShowOverlayPlayNote(false),
                            textBold: "X",
                          ),
                        ),
                        MyDivider(),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                MyRoundedEdgeText(
                                  textBold:
                                      model.getNoteDisplayName(chord.note.id),
                                  textNormal: chord.chordType.sigla,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                MyRoundedEdgeText(
                                  textNormal: chord.chordType.nome,
                                ),
                              ],
                            ),
                          ],
                        ),
                        // MyRoundedEdgeText(
                        //   textBold: model.getNoteDisplayName(chord.note.name),
                        //   textNormal: chord.chordType.sigla,
                        // ),
                        MyDivider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: model.getShowOverlayPlayNoteChord.notes
                              .map((note) => MyRoundedEdgeText(
                                    textBold: model.getNoteDisplayName(note.id),
                                    textNormal: "${note.octave}",
                                  ))
                              .toList(),
                        ),
                        _buildChordDetails(chord),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
      child: SizedBox.shrink(),
    );
  }

  Widget _buildButtonScaleType(BuildContext context, ViewModelChoose model) {
    return MyRoundedEdgeText(
      //MyRoundedEdgeButton(
      textNormal: model.getSelectedScaleType.toString(),
      onPressed: () => showDialog(
        context: context,
        builder: (_) => ChangeNotifierProvider.value(
          value: model,
          child: Consumer<ViewModelChoose>(
            builder: (_, model, child) => MyDialog(
              title: "Seleziona tipo scala",
              child: Wrap(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: model.getScaleTypes
                    .map(
                      (scaleType) => MyRoundedEdgeButton(
                          textNormal: scaleType.name,
                          onPressed: () => model.setScaleType(scaleType),
                          selected:
                              model.getSelectedScaleType.name == scaleType.name
                                  ? true
                                  : false),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChordsByTonic2(BuildContext context, ViewModelChoose model) {
    double kTileW = MediaQuery.of(context).size.width / 16;// 15;
    double kTileH = kTileW;
    //int kRows = 7;

    //ViewModelSettings modelSettings = Provider.of<ViewModelSettings>(context);
    final ViewModelAudioToggle modelAudioToggle =
        Provider.of<ViewModelAudioToggle>(context);

    return SingleChildScrollView(
        primary: true,
        scrollDirection: Axis.vertical,
        // child: SizedBox(
        //   width: MediaQuery.of(context).size.width,
        //   height: kRows*kTileH, //MediaQuery.of(context).size.height * 0.5,
        child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: model.getChordTypesByGruppoMap.keys
                .map((e) => Row(children: <Widget>[
                      RotatedBox(
                        quarterTurns: 1,
                        child: Text(e),
                      ),
                      Row(
                          children: List.generate(
                              8,
                              (key) => key == 0
                                  ? Column(
                                      children: <Widget>[] +
                                          [Text("")] +
                                          model.getChordTypesByGruppoMap[e]
                                              .map((chordType) {
                                            return TextTile(
                                              text: "${chordType.sigla}",
                                              kTileW: kTileW * 4,
                                              kTileH: kTileH,
                                            );
                                          }).toList())
                                  : Column(
                                      children: <Widget>[
                                            Text(
                                                "${model.getScale[key - 1].id}")
                                          ] +
                                          model.getChordTypesByGruppoMap[e]
                                              .map((chordType) {
                                            Note note = model.getScale[key - 1];
                                            int index = model
                                                .getChordsByNoteMap[note.id]
                                                .indexWhere((chord) =>
                                                    chord.chordType.nome ==
                                                    chordType.nome);
                                            if (index != -1) {
                                              Chord chord =
                                                  model.getChordsByNoteMap[
                                                      note.id][index];
                                              return ChordTile(
                                                chord: chord,
                                                kTileW: kTileW,
                                                kTileH: kTileH,
                                                onPressed: () => playChord(
                                                    model,
                                                    chord,
                                                    modelAudioToggle
                                                        .getAudioOn),
                                              );
                                            }

                                            /*return index != -1
                                              ? TextTile(
                                                  text: chordType.sigla,
                                                  kTileW: kTileW,
                                                  kTileH: kTileH,
                                                )
                                              :*/
                                            return TextTile(
                                              text: "",
                                              kTileW: kTileW,
                                              kTileH: kTileH,
                                            );
                                            /*? ListTile(
                                                  /*onTap: () => playChord(model,
                                                      chord, model.getAudioOn),*/
                                                  title: Text(
                                                      "${chordType.sigla}"),
                                                )
                                              : TextTile(
                                                  text: "",
                                                  kTileW: kTileW,
                                                  kTileH: kTileH,
                                                );*/
                                          }).toList(),
                                    )).toList()),
                    ]))
                .toList())

        // GridView.count(
        //   crossAxisSpacing: 0,
        //   mainAxisSpacing: 0,
        //   padding: EdgeInsets.all(0),
        //     scrollDirection: Axis.horizontal,
        //     crossAxisCount: kRows, // n rows
        //     children: model.getChords
        //         .map(
        //           (c) => ChordTile(chord: c),
        //           //),
        //         )
        //         .toList()
        //     //}
        //     ),
        //),
        //),
        );
  }
}

//   Widget _buildBigGrid(BuildContext context, ViewModelChoose model) {

//     BigTable bt = BigTable(model.getScale, model.getChordTypes);

//     Map<String, List<Chord>> m = Map<String, List<Chord>>();
//     // create chord type name map
//     for (Chord c in model.getChords) {
//       bt.set(c.note.id, c.chordType.sigla, true);
//     }

//     final tiles = elements
//         .map((element) => element != null
//             ? ChordTile(element)
//             : Container(color: Colors.black38, margin: kGutterInset,))
//         .toList();

//     return SingleChildScrollView(
//       child: SizedBox(
//         height: kRowCount * (kContentSize + (kGutterWidth * 2)),
//         child: BigTableWidget()
//       ),
//     );
//   }
// }

// class BigTableWidget extends StatelessWidget {

//   final BigTable bt;

//   const BigTableWidget({Key key, this.bt}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ViewModelChoose model = Provider.of<ViewModelChoose>(context);

//     return SingleChildScrollView(
//       child: SizedBox(
//         height: kRowCount * (kContentSize + (kGutterWidth * 2)),
//         child:
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               child:
//               Row(children: <Widget>[
//                 Container(width: kContentSize),
//                 Row(children: model.getChordTypes.map((ct)=>
//                 Container(width:kContentSize, child: Text(ct.sigla),),).toList()
//                 ,)
//               ],)
//               ,),
//             Container(
//               child: Row(children: <Widget>[

//               ],)
//               ,)
//           ],
//         )

//         GridView.count(
//           crossAxisCount: bt.width, // kRowCount,
//           children: tiles,
//           scrollDirection: Axis.horizontal,),),);

//   }

// }

// class BigTableColumn {

//   // chordType.sigla yes/no
//   Map<String, bool> _m = Map<String, bool>();

//   int get length => _m.length;

//   void set(String chordID, bool yes) => _m[chordID] = yes;

//   BigTableColumn(List<ChordType> listChordTypes) {
//     for (int j=0; j<listChordTypes.length; j++){
//         ChordType ct = listChordTypes[j];

//         _m[ct.sigla] = false;
//     }
//   }
// }

// class BigTable {

//   // tonic note, list of chord types
//   Map<String, BigTableColumn> _m = Map<String, BigTableColumn>();
//   int get numberOfNotes => _m.length;
//   int get numberOfChords => _m[0].length;

//   void set(String noteID, String chordID, bool yes) {
//     _m[noteID].set(chordID, yes);
//   }

//   BigTable(List<Note> listNotes, List<ChordType> listChordTypes) {
//     for (int i=0; i<listNotes.length; i++){
//       Note n = listNotes[i];

//       BigTableColumn btc = BigTableColumn(listChordTypes);
//       _m[n.id] = btc;
//     }
//   }

// }

// const int kRowCount = 10;
// const double kContentSize = 64.0;
// const double kGutterWidth = 2.0;
// const kGutterInset = EdgeInsets.all(kGutterWidth);

// class ChordTile extends StatelessWidget {
//   final Chord element;
//   final bool isLarge;

//   const ChordTile({Key key, this.element, this.isLarge}) : super(key: key);

//   Size get preferredSize => Size.fromHeight(kContentSize * 1.5);

//   @override
//   Widget build(BuildContext context) {
//     final tileText = <Widget>[
//       Align(
//         alignment: AlignmentDirectional.centerStart,
//         child: Text('${element.number}', style: TextStyle(fontSize: 10.0)),
//       ),
//       Text(element.symbol, style: Theme.of(context).primaryTextTheme.headline),
//       Text(
//         element.name,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         textScaleFactor: isLarge ? 0.65 : 1,
//       ),
//     ];

//     final tile = Container(
//       margin: kGutterInset,
//       width: kContentSize,
//       height: kContentSize,
//       foregroundDecoration: BoxDecoration(
//         gradient: LinearGradient(colors: element.colors),
//         backgroundBlendMode: BlendMode.multiply,
//       ),
//       child: RawMaterialButton(
//         onPressed: !isLarge
//             ? () => Navigator.push(
//                 context, MaterialPageRoute(builder: (_) => DetailPage(element)))
//             : null,
//         fillColor: Colors.grey[800],
//         disabledElevation: 10.0,
//         padding: kGutterInset * 2.0,
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: tileText),
//       ),
//     );

//     return Hero(
//       tag: 'hero-${element.symbol}',
//       flightShuttleBuilder: (_, anim, __, ___, ____) => ScaleTransition(
//           scale: anim.drive(Tween(begin: 1, end: 1.75)), child: tile),
//       child: Transform.scale(scale: isLarge ? 1.75 : 1, child: tile),
//     );
//   }
// }

class TextTile extends StatelessWidget {
  final String text;
  final double kTileW;
  final double kTileH;

  const TextTile(
      {Key key,
      @required this.text,
      @required this.kTileW,
      @required this.kTileH})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final ViewModelChoose model = Provider.of<ViewModelChoose>(context);

    return SizedBox(
      width: kTileW,
      height: kTileH,
      child: Padding(
        padding: EdgeInsets.fromLTRB(1, 1, 0, 0),
        child: Container(
          //padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
          alignment: Alignment.center,
          color: Config.COLOR_LS,
          child: Text("$text", style: TextStyle(color: Config.COLOR_DS)),
        ),
      ),
    );
  }
}

class ChordTile extends StatelessWidget {
  final Chord chord;
  final double kTileW;
  final double kTileH;
  final Function onPressed;

  const ChordTile(
      {Key key,
      @required this.chord,
      @required this.kTileW,
      @required this.kTileH,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ViewModelChoose model = Provider.of<ViewModelChoose>(context);

    return SizedBox(
      width: kTileW,
      height: kTileH,
      child: Container(
          alignment: Alignment.center,
          color: Colors.red,
          child: MaterialButton(
            onPressed: onPressed,
            child: Icon(Icons.play_arrow),
            /*Text(
                "${model.getNoteDisplayName(chord.note.id)} ${chord.chordType.sigla}"),*/
          )),
    );
  }
}
