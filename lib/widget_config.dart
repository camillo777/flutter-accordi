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
                Divider(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Ottava", style: Config.TS_TITLE),
                    CustomButton(
                      onPressed: () => model.decOctave(), 
                      text: "-",
                      enabled: model.getSelectedOctave>0?true:false,
                    ),
                    Text(model.getSelectedOctave.toString(), style: TextStyle(fontSize: 32)),
                    CustomButton(
                      onPressed: () => model.incOctave(), 
                      text: "+", 
                      enabled: model.getSelectedOctave<7?true:false,
                      ),
                  ],
                ),
                Divider(
                  height: 15,
                ),
                Text("Tonica", style: Config.TS_TITLE),
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
                Text("Tipo scala", style: Config.TS_TITLE),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("BPM", style: Config.TS_TITLE),
                    CustomButton(
                      onPressed: () async => await model.decBpm(), 
                      text: "-",
                      enabled: model.getBpm>0?true:false,
                    ),
                    Text(model.getBpm.toString(), style: TextStyle(fontSize: 32)),
                    CustomButton(
                      onPressed: () async => await model.incBpm(), 
                      text: "+", 
                      enabled: model.getBpm<200?true:false,
                      ),
                  ],
                ),
                Divider(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Mostra accordi per tipo", style: Config.TS_TITLE),
                    Switch(
                      onChanged: (bool value) async => await model.setDisplayChordsByType(value),
                      value: model.getDisplayChordsByType,
                      activeColor: Config.COLOR_MAIN,
                      activeTrackColor: Config.COLOR_MAIN,
                    ),
                  ],
                ),
                Divider(
                  height: 15,
                ),
                ],
                );
  }
  
}