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

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
              "Scala ${model.getSelectedTonic} ${model.getSelectedScaleType.name}",
              style: Config.TS_TITLE),
          model.getScale == null
              ? Text("Seleziona una tonica e il tipo di scala...",
                  style: Config.TS_VALUE)
              : Container(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buildScale(model),
                )),
          Divider(
            height: 15,
          ),
          Text("Accordi possibili nella scala", style: Config.TS_TITLE),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: model.getDisplayChordsByType
                ? _buildChordsByType(context, model)
                : _buildChords(context, model),
          ),
          Divider(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildChordDetails(model.getSelectedChord)),
          ),
          // Divider(
          //   height: 15,
          // ),
          // CustomButton(
          //     onPressed: () => model.addChordToCompo(),
          //     text: "Aggiungi accordo"),
        ],
      ),
    );
  }

  List<Widget> _buildChordDetails(Chord chord) {
    List<Widget> list = List<Widget>();

    //Chord chord =model.getSelectedChord; //model.getChords[ model.getSelectedChord ];

    if (chord == null) return list;

    list.add(
        _buildChordDetailsLine("Accordo selezionato", chord.toString(), true));
    list.add(_buildChordDetailsLine(
        "Tipo di accordo: ", chord.chordType.nome, false));
    list.add(_buildChordDetailsLine("Gruppo:", chord.chordType.gruppo, false));
    list.add(
        _buildChordDetailsLine("Sigla accordo", chord.chordType.sigla, false));
    list.add(_buildChordDetailsLine(
        "Gradi dell'accordo:", chord.chordType.gradi.join(","), false));
    list.add(_buildChordDetailsLine(
        "Note dell'accordo:", chord.notes.join(","), false));

    return list;
  }

  Widget _buildChordDetailsLine(String label, String value, bool title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("$label", style: title ? Config.TS_TITLE : Config.TS_LABEL),
        Text("$value", style: title ? Config.TS_TITLE : Config.TS_VALUE),
      ],
    );
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

  Widget _buildNote(ViewModelHome model, Note note, bool selected) {
    return InkWell(
      //onTap: () => model.playMidiNote(note),
      onTap: () {
        int midiNote = model.getMidiNote(note);
        log.i("midiNote:$midiNote");
        //if (loaded){
        log.i("ply MIDI note");
        player.playMidiNote(midiNote);
        //}
      },
      onLongPress: () => model.toggleSelectedNote(note),
      child: Container(
        color: selected ? model.getColorForNote(note).back : Config.COLOR_BACK,
        padding: EdgeInsets.all(15),
        child: Text(
          "${note.toString()}",
          style: TextStyle(
              color: selected ? Config.COLOR_TEXT : Config.COLOR_TEXT_MAIN),
        ),
      ),
    );
  }

  List<Widget> _buildScale(ViewModelHome model) {
    List<Widget> list = List<Widget>();

    bool b = true;

    for (int i = 0; i < model.getScale.length; i++) {
      Note note = model.getScale[i];

      b = !b;

      list.add(_buildNote(model, note, model.isNoteSelected(note)));
    }
    return list;
  }

  List<Widget> _buildChordsByType(BuildContext context, ViewModelHome model) {
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
            child: Text(k, style: Config.TS_LABEL),
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
                          model.isNoteSelected(chord.tonic)
                              ? model.getColorForNote(chord.tonic).back
                              : Config.COLOR_MAIN,
                        ),
                        //Text(chord.toString(), style: Config.TS_VALUE)
                      )
                      .toList())),
        ],
      ));
    });

    return l;
  }

  List<Widget> _buildChords(BuildContext context, ViewModelHome model) {
    List<Widget> list = List<Widget>();

    String prev = "";
    List<Widget> lw;
    bool b = true;
    for (int i = 0; i < model.getChords.length; i++) {
      Chord chord = model.getChords[i];

      if (!model.isNoteSelected(chord.tonic)) continue;

      if (prev != chord.tonic.name) {
        if (lw != null)
          list.add(
              //Container(
              //  color: b ? Config.COLOR_MAIN : Config.COLOR_MAIN_ALT,
              //  child:
              Wrap(
                runAlignment: WrapAlignment.spaceEvenly,
            children: lw,
          )
              //,)
              );
        b = !b;

        lw = List<Widget>();
        prev = chord.tonic.name;
      }

      lw.add(
        _buildChord(
          context,
          model,
          chord,
          model.isNoteSelected(chord.tonic)
              ? model.getColorForNote(chord.tonic).back
              : Config.COLOR_MAIN,
        ),
      );
    }
    if (lw != null)
      list.add(Wrap(
        children: lw,
      ));

    return list;
  }

  Widget _buildChord(
      BuildContext context, ViewModelHome model, Chord chord, Color c) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (_) => ChangeNotifierProvider.value(
            value: model,
            child: LogoutOverlay(chord), //, model),
          ),
        ), //playChord(model, chord),
        onLongPress: () =>
            model.setSelectedChord(chord), //model.addChordToCompo(chord),
        child: Container(
          width: MediaQuery.of(context).size.width / 3.5,
          padding: EdgeInsets.all(12),
          color: model.getSelectedChord == chord
              ? Config.COLOR_MAIN_SEL
              : c, //Config.COLOR_MAIN,
          child: Text(
            chord.toString(),
            style: TextStyle(
              color: model.getSelectedChord == chord
                  ? Config.COLOR_TEXT_SEL
                  : Config.COLOR_TEXT,
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutOverlay extends StatefulWidget {
  final Chord chord;
  //final ViewModelHome model;

  LogoutOverlay(this.chord); //, this.model);

  @override
  State<StatefulWidget> createState() => LogoutOverlayState();
}

class LogoutOverlayState extends State<LogoutOverlay>
    with SingleTickerProviderStateMixin {
  final log = getLogger("LogoutOverlayState");

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final ViewModelHome model = Provider.of<ViewModelHome>(context);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(15.0),
            //height: 180.0,
            decoration: ShapeDecoration(
              //color: Color.fromRGBO(41, 167, 77, 10),
              color: Config.COLOR_BACK,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: _buildChordDetails(widget.chord),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomButton(
                        onPressed: () => playChord(model, widget.chord),
                        text: "Play",
                      ),
                      CustomButton(
                        onPressed: () => model.addChordToCompo(widget.chord),
                        text: "Aggiungi",
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChordDetails(Chord chord) {
    List<Widget> list = List<Widget>();

    //Chord chord =model.getSelectedChord; //model.getChords[ model.getSelectedChord ];

    if (chord == null) return list;

    list.add(
        _buildChordDetailsLine("Accordo selezionato", chord.toString(), true));
    list.add(
      SizedBox(
        height: 20,
      ),
    );
    list.add(_buildChordDetailsLine(
        "Tipo di accordo: ", chord.chordType.nome, false));
    list.add(_buildChordDetailsLine("Gruppo:", chord.chordType.gruppo, false));
    list.add(
        _buildChordDetailsLine("Sigla accordo", chord.chordType.sigla, false));
    list.add(_buildChordDetailsLine(
        "Gradi dell'accordo:", chord.chordType.gradi.join(","), false));
    list.add(_buildChordDetailsLine(
        "Note dell'accordo:", chord.notes.join(","), false));

    return list;
  }

  Widget _buildChordDetailsLine(String label, String value, bool title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("$label", style: title ? Config.TS_TITLE : Config.TS_LABEL),
        Text("$value", style: title ? Config.TS_TITLE : Config.TS_VALUE),
      ],
    );
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
}
