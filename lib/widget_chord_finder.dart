import 'package:accordi/logger.dart';
import 'package:accordi/service_scale.dart';
import 'package:accordi/viewmodel_chord_finder.dart';
import 'package:accordi/widget_custombutton.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'config.dart';

class WidgetChordFinder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WidgetChordFinderState();
  }
}

class _WidgetChordFinderState extends State<WidgetChordFinder> {
  final log = getLogger("_WidgetChordFinderState");

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewModelChordFinder>(
      create: (_) => ViewModelChordFinder(),
      child: Consumer<ViewModelChordFinder>(
        builder: (_, modelCF, child) => Center(
          child: Container(
            alignment: Alignment.topCenter,
            width:
                MediaQuery.of(context).size.width * Config.WIDTH_PERCENT_DIALOG,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildString(modelCF, 0),
                _buildString(modelCF, 1),
                _buildString(modelCF, 2),
                _buildString(modelCF, 3),
                _buildString(modelCF, 4),
                _buildString(modelCF, 5),
                MyDivider(),
                Text("${modelCF.getSelectedNotes.join(",")}"),
                MyDivider(),
                Text(
                    "${modelCF.getSelectedChords.map((fc) => fc.missingNotes.length == 0 ? "${fc.chord.note.id} ${fc.chord.chordType.sigla} (${fc.chord.chordType.nome})" : "").join(", ")}"),
                MyDivider(),
                Text(
                    "${modelCF.getSelectedChords.map((fc) => "${fc.chord.chordType.sigla} ${fc.missingNotes.join(",")}").join(", ")}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildString(ViewModelChordFinder modelCF, int string) {
    List<int> frets = modelCF.getGuitarNeck[string];

    List<Widget> list = List<Widget>();

    //selectedNotes.clear();

    for (int i = 0; i < frets.length; i++) {
      int fret = frets[i];

      String noteID = modelCF.getNoteID(string, i);
      //log.i("noteID:$noteID");

      //if (fret==1) selectedNotes.add(noteID);

      list.add(fret == 1
          ? MyRoundButton2(
              textBold: "${modelCF.getNoteDisplayName(noteID)}",
              onPressed: () => modelCF.toggle(string, i),
            )
          : MyRoundButton2(
              textNormal: "$noteID",
              onPressed: () => modelCF.toggle(string, i),
              dark: false));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }
}
