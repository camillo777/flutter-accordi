import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'player.dart';
import 'viewmodel_home.dart';

import 'logger.dart';
import 'widget_compose.dart';
import 'widget_choose.dart';
import 'widget_config.dart';

class WidgetHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WidgetHomeState();
  }
}

class _WidgetHomeState extends State<WidgetHome>
    with SingleTickerProviderStateMixin {
  final log = getLogger("_WidgetHomeState");

  TabController _tabController;

  @override
  void initState() {
    log.i("initState");

    player.load(DefaultAssetBundle.of(context));

    super.initState();

    _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewModelHome>(
        create: (_) => ViewModelHome(),
        child: Consumer<ViewModelHome>(builder: (_, model, child) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TabBar(
                  labelColor: Colors.blue,
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.settings),
                      text: 'Config',
                    ),
                    Tab(
                      icon: Icon(Icons.music_note),
                      text: 'Choose',
                    ),
                    Tab(
                      icon: Icon(Icons.queue_music),
                      text: 'Compose',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    WidgetConfig(),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        //color: Config.COLOR_MAIN,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            //color: Config.COLOR_MAIN,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 135, 155, 155),
                                blurRadius:
                                    5.0, // has the effect of softening the shadow
                                spreadRadius:
                                    0, // has the effect of extending the shadow
                                offset: Offset(
                                  1.0, // horizontal, move right 10
                                  1.0, // vertical, move down 10
                                ),
                              )
                            ],
                            borderRadius:
                                new BorderRadius.all(Radius.circular(5)),
                            color: Color.fromARGB(255, 235, 255, 255),
                            // gradient: new LinearGradient(
                            //   colors: [
                            //   Color.fromARGB(255, 250, 250, 250),
                            //   Color.fromARGB(255, 260, 260, 260),
                            // ]),
                          ),
                          child: WidgetChoose()),
                    ),
                    WidgetCompose(),
                  ]),
                ),
              ]);
        }));
  }
}
