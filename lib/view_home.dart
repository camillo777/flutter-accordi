import 'package:accordi/viewmodel_audiotoggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;

import 'config.dart';
import 'view_settings.dart';
import 'viewmodel_home.dart';
import 'viewmodel_startup.dart';
import 'widget_choose.dart';
import 'widget_chord_finder.dart';
import 'widget_composer.dart';
import 'widget_custombutton.dart';
import 'widget_home.dart';

class ViewHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accordi App',
      home: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: Config.COLOR_DS,
            appBar: AppBar(
              leading: Consumer<ViewModelHome>(builder: (_,modelHome,child) => IconButton(
                          icon: Icon(Icons.home, color: Config.COLOR_LS),
                          onPressed: () => modelHome.setCurrentPage(AppPage.Home),
                          ),
                        ),
              title: TextTitle(text: "Accordi"),
              //leading: ,
              elevation: 0,
              //shape: ShapeBorderClipper,
              backgroundColor: Config.COLOR_DS,
              toolbarOpacity: 1,
              //bottom: ,
              //bottomOpacity: ,
              //textTheme: TextTheme(title: Config.TS_TITLE),
              actions: <Widget>[
                Consumer<ViewModelStartup>(
                  builder: (_, modelStartup, child) => !modelStartup.isReady
                      ? SizedBox.shrink()
                      : Consumer<ViewModelAudioToggle>(
                          builder: (_, modelAudioToggle, child) => IconButton(
                            icon: modelAudioToggle.getAudioOn
                                ? Icon(Icons.volume_up, color: Config.COLOR_LS)
                                : Icon(Icons.volume_off,
                                    color: Config.COLOR_LS),
                            onPressed: () => modelAudioToggle.toggleAudioOn(),
                          ),
                        ),
                ),
                Consumer<ViewModelStartup>(
                  builder: (_, modelStartup, child) => !modelStartup.isReady
                      ? SizedBox.shrink()
                      : IconButton(
                          icon: Icon(Icons.settings, color: Config.COLOR_LS),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewSettings(),
                            ),
                          ),
                        ),
                )
              ],
            ),
            body: Consumer<ViewModelStartup>(
                  builder: (_, modelStartup, child) => !modelStartup.isReady
                      ? CircularProgressIndicator()
                      : Consumer<ViewModelHome>(builder: (_,model,child) { 
                          //return WidgetChoose();
                          switch(model.getCurrentPage){
                            case AppPage.FindChord: return WidgetChordFinder();
                            case AppPage.MakeScale: return WidgetChoose();
                            case AppPage.Composer: return WidgetComposer();
                            default: return WidgetHome();
                          }
                      }),),
      ),
    ),);
  }
}
