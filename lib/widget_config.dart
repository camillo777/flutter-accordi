import 'viewmodel_home.dart';
import 'widget_custombutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config.dart';


class WidgetConfig extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    ViewModelHome model = Provider.of<ViewModelHome>(context);
    
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
                )]
                );
  }
  
}