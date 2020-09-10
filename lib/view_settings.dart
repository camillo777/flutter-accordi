import 'package:accordi/viewmodel_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'widget_custombutton.dart';

class ViewSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.COLOR_DS,
      appBar: AppBar(
        title: Text("Settings"),
        elevation: 0,
        backgroundColor: Config.COLOR_DS,
        toolbarOpacity: 1,
      ),
      body: Center(
        child: Consumer<ViewModelSettings>(
            builder: (_, modelSettings, child) => Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextTitle(text: "Note language"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextLabel(text:"C,D,E,..."),
                            Switch(
                              onChanged: (value) =>
                                  modelSettings.setNoteLang(value),
                              value: modelSettings.getNoteLang(),
                              activeColor: Config.COLOR_LS,
                              activeTrackColor: Config.COLOR_LA,
                            ),
                            TextLabel(text:"DO,RE,MI,..."),
                          ],
                        ),
                      ],
                    ),
                    MyDivider(),
                    Column(children: <Widget>[
                      TextTitle(text: "Note enharmonics"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextLabel(text:"#"),
                          Switch(
                            onChanged: (value) =>
                                modelSettings.setNoteEnharmonic(value),
                            value: modelSettings.getNoteEnharmonic(),
                            activeColor: Config.COLOR_LS,
                            activeTrackColor: Config.COLOR_LA,
                          ),
                          TextLabel(text:"b"),
                        ],
                      ),
                    ]),
                    MyDivider(),
                    Column(children: <Widget>[
                      TextTitle(text: "BPM"),
                      Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextLabel(text: "BPM"),
                    MyRoundButton2(
                      onPressed: () async => await modelSettings.decBpm(10), 
                      textBold: "-10",
                      enabled: modelSettings.getBpm>0?true:false,
                    ),
                    MyRoundButton2(
                      onPressed: () async => await modelSettings.decBpm(1), 
                      textBold: "-",
                      enabled: modelSettings.getBpm>0?true:false,
                    ),
                    Text(modelSettings.getBpm.toString(), style: TextStyle(fontSize: 32)),
                    MyRoundButton2(
                      onPressed: () async => await modelSettings.incBpm(1), 
                      textBold: "+", 
                      enabled: modelSettings.getBpm<200?true:false,
                      ),
                    MyRoundButton2(
                      onPressed: () async => await modelSettings.incBpm(10), 
                      textBold: "+10", 
                      enabled: modelSettings.getBpm<200?true:false,
                      ),
                  ],
                ),
                    ],)
                    // RaisedButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text('Go back!'),
                    // ),
                  ],
                )),
      ),
    );
  }
}
