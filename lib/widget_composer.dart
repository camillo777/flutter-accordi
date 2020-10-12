import 'package:accordi/viewmodel_composer.dart';

import 'widget_custombutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;

import 'config.dart';
import 'logger.dart';
import 'player.dart';
import 'service_scale.dart';
import 'viewmodel_home.dart';

class WidgetComposer extends StatelessWidget {
  final log = getLogger("WidgetCompose");

  @override
  Widget build(BuildContext context) {
  
    return 
    ChangeNotifierProvider(
      create: (_) => ViewModelComposer(),
      child: Consumer<ViewModelComposer>(
        builder: (_, model, child) {
          return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          padding: EdgeInsets.all(3),
          children: 
            List.generate(20, (index)=>Text("$index"))
            //_buildChords(model),
        )),
        // MyRoundButton2(onPressed: () => playCompo(model), textBold: "play stop"),
        // MyRoundButton2(onPressed: () => model.clearCompo(), textBold: "clear"),
      ],
    );
        })
      );
        
  }

  // List<Widget> _buildChords(ViewModelHome model) {
  //   List<CompoChord> list = model.getComposition.getComposition;
  //   List<Widget> listWidget = List<Widget>();

  //   for (int i = 0; i < list.length; i++) {
  //     CompoChord chord = list[i];

  //     listWidget.add(_textWithPadding(model, chord.getChord.toString(), i));
  //   }

  //   return listWidget;
  // }

  // Widget _textWithPadding(ViewModelHome model, String text, int index) {
  //   return InkWell(
  //     onLongPress: () => model.setSelectedCompoSlot(index),
  //     child: Container(
  //       alignment: Alignment.center,
  //       color: model.selectedCompoSlot == index
  //           ? Config.COLOR_BG_SEL
  //           : Config.COLOR_BG,
  //       child: Text(text,
  //           style: TextStyle(
  //             fontSize: 20,
  //             color: model.selectedCompoSlot == index
  //                 ? Config.COLOR_TX_SEL
  //                 : Config.COLOR_TX,
  //           )),
  //     ),
  //   );
  // }

  // List<ReorderableTableRow> _buildRows(ViewModelHome model) {
  //   List<ReorderableTableRow> rows = List<ReorderableTableRow>();

  //   const int COLS = 4;

  //   List<CompoChord> compo = model.getComposition.getComposition;

  //   log.i("compo.length:${compo.length}");
  //   int r = compo.length % COLS;

  //   log.i("r:$r");
  //   int nrows = ((compo.length - r) / COLS).floor() + 1;
  //   log.i("nrows:$nrows");

  //   for (int i = 0; i < nrows; i++) {
  //     // righe

  //     List<Widget> row = List<Widget>();

  //     for (int j = 0; j < COLS; j++) {
  //       // colonne
  //       int index = i * COLS + j;
  //       log.i("index:$index");

  //       if (index >= compo.length) {
  //         log.i("break");
  //         break;
  //       }

  //       String itemKey = "camillo_item$i$j";
  //       log.i("itemKey:$itemKey");
  //       Widget text = Container(
  //         key: Key(itemKey),
  //         child: Text(
  //           compo[index].chord.toString(),
  //         ),
  //       );
  //       row.add(text);
  //     }

  //     String rowKey = "camillo_row$i";
  //     log.i("rowKey:$rowKey");
  //     rows.add(
  //       ReorderableTableRow(
  //         key: Key(rowKey),
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: row,
  //       ),
  //     );
  //   }

  //   return rows;
  // }

  // Future<void> playCompo(ViewModelHome model) async {
  //   log.i("playCompo");

  //   double bpm = model.getBpm.toDouble(); // 90;
  //   int noteDuration = (1000 * (bpm / 60) / 4).floor();
  //   log.i("noteDuration:$noteDuration");

  //   //int noteDuration = (1000 / chord.notes.length).floor();

  //   for (int j = 0; j < model.getComposition.getComposition.length; j++) {
  //     CompoChord compoChord = model.getComposition.getComposition[j];

  //     for (int i = 0; i < 4; i++) {
  //       int index = i;
  //       if (index >= compoChord.getChord.notes.length) {
  //         index = index - (4 - compoChord.getChord.notes.length) -1;
  //         //index = index - 1;
  //       }

  //       Note n = compoChord.getChord.notes[index];
  //       log.i("play:${n.toString()}");
  //       int note = model.getMidiNote(n);
  //       player.playMidiNote(note);
  //       await Future.delayed(Duration(milliseconds: noteDuration), () => "1");
  //     }
  //   }
  // }
}
