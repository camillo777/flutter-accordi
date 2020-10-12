import 'package:accordi/widget_chord_finder.dart';
import 'package:accordi/widget_custombutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide BuildContext;
import 'config.dart';
import 'player.dart';

import 'logger.dart';
import 'viewmodel_home.dart';
import 'widget_choose.dart';

class WidgetHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WidgetHomeState();
  }
}

class _WidgetHomeState extends State<WidgetHome>
    with SingleTickerProviderStateMixin {
  final log = getLogger("_WidgetHomeState");

  //TabController _tabController;

  @override
  void initState() {
    log.i("initState");

    player.load(DefaultAssetBundle.of(context));

    super.initState();

    //_tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    log.i("build");

    ViewModelHome modelHome = Provider.of<ViewModelHome>(context);
    
    return 
      Center(child: Container(
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width * Config.WIDTH_PERCENT_DIALOG,
      child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MyRoundedEdgeText(
            onPressed: () => modelHome.setCurrentPage(AppPage.FindChord),
            textBold: "Chord Finder",
          ),
          MyDivider(),
          MyRoundedEdgeText(
            onPressed: () => modelHome.setCurrentPage(AppPage.MakeScale),
            textBold: "Scale & Chord maker",
          )
      ],),),);
    
     // WidgetChoose()
          // return Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       TabBar(
          //         labelColor: Config.COLOR_INV_TX,
          //         controller: _tabController,
          //         tabs: <Widget>[
          //           Tab(
          //             icon: Icon(Icons.settings),
          //             text: 'Config',
          //           ),
          //           Tab(
          //             icon: Icon(Icons.music_note),
          //             text: 'Choose',
          //           ),
          //           Tab(
          //             icon: Icon(Icons.queue_music),
          //             text: 'Compose',
          //           ),
          //         ],
          //       ),
          //       Expanded(
          //         child: TabBarView(controller: _tabController, children: [
          //           WidgetConfig(),
          //           WidgetChoose(),
          //           WidgetCompose(),
          //         ]),
          //       ),
          //     ]);
        //}),
        //);
  }

  // Widget _buildCard(Widget child) {
  //   return Padding(
  //     padding: EdgeInsets.all(20),
  //     child: Container(
  //         //color: Config.COLOR_MAIN,
  //         padding: EdgeInsets.all(10),
  //         decoration: BoxDecoration(
  //           //color: Config.COLOR_MAIN,
  //           boxShadow: [
  //             BoxShadow(
  //               color: Color.fromARGB(255, 135, 155, 155),
  //               blurRadius: 5.0, // has the effect of softening the shadow
  //               spreadRadius: 0, // has the effect of extending the shadow
  //               offset: Offset(
  //                 1.0, // horizontal, move right 10
  //                 1.0, // vertical, move down 10
  //               ),
  //             )
  //           ],
  //           borderRadius: new BorderRadius.all(Radius.circular(5)),
  //           color: Color.fromARGB(255, 235, 255, 255),
  //           // gradient: new LinearGradient(
  //           //   colors: [
  //           //   Color.fromARGB(255, 250, 250, 250),
  //           //   Color.fromARGB(255, 260, 260, 260),
  //           // ]),
  //         ),
  //         child: child),
  //   );
  // }
}
