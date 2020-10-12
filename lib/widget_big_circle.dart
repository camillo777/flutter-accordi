import 'dart:math';

import 'package:accordi/viewmodel_choose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'logger.dart';

class BigCircle extends StatefulWidget {
  final List<String> notes;

  const BigCircle({Key key, @required this.notes}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BigCircleState();
  }
}

class _BigCircleState extends State<BigCircle> with TickerProviderStateMixin {
  final log = getLogger("_BigCircleState");

  AnimationController animationController1;
  Animation<double> animation1;
  //Animation<double> animation2;
  bool forward;

  @override
  void initState() {
    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation1 = Tween<double>(
      begin: 0.95,
      end: 1, //pi / 100,
    ).animate(
      CurvedAnimation(
        parent: animationController1,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );
    //animation2 =
    //    Tween<double>(begin: pi / 100, end: 0).animate(animationController1);
    forward = true;
    // animationController1.addStatusListener((animStatus) {
    //   if (animStatus == AnimationStatus.completed) {
    //     forward = !forward;
    //   }
    // });
    animationController1.repeat(reverse: true);
    //animationController1.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController1?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ViewModelChoose model = Provider.of<ViewModelChoose>(context);

    return Center(
        child: Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
          animation: animation1,
          builder: (context, child) {
            return Stack(
              fit: StackFit.loose,
              children: _getList(model, animation1.value),
            );
          }),
    ));
  }

  List<Widget> _getList(ViewModelChoose model, double animOffset) {
    List<Widget> list = List<Widget>();

    double screenWidth = min( MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    double parentWidth = screenWidth * 0.8;
    double circlew = screenWidth * 0.3;

    list.add(
      Container(
        color: Colors.transparent,
        width: parentWidth,
        height: parentWidth,
      ),
    );

    //return list;

    Widget bigCircle = Positioned(
      left: (parentWidth / 2) - (circlew / 2),
      top: (parentWidth / 2) - (circlew / 2),
      child: 
      InkResponse(
      onTap: () => model.setShowOverlayTonicChooser(false), //  Navigator.pop(context),
      child: Container(
        alignment: Alignment.center,
        width: circlew,
        height: circlew,
        //height: MediaQuery.of(context).size.height/1.5,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
          // border: Border.all(
          //   color: Colors.black,
          //   width: 3.0,
          // ),
        ),
        child: Center(
          child: Text(
            model.getNoteDisplayName( model.getSelectedTonic ),
            style: TextStyle(
              color: Config.COLOR_TX,
              fontSize: 48,
            ),
          ),
        ),
      ),
    ),);
    list.add(bigCircle);

    //Point p = Point(0, 0);
    double all = 2 * pi;
    double step = all / widget.notes.length;

    for (int i = 0; i < widget.notes.length; i++) {
      String note = widget.notes[i];
      String noteDisplayName = model.getNoteDisplayName( note );

      const double cw = 50; // icon with/height
      double xu = animOffset * cos(pi / 2 + i * -step);
      double yu = animOffset * sin(pi / 2 + i * -step);
      //log.i("xu: $xu, yu: $yu");
      double x = (parentWidth / 2) - (parentWidth / 2 - cw / 2) * xu;
      double y = (parentWidth / 2) - (parentWidth / 2 - cw / 2) * yu;
      //log.i("x: $x, y: $y");

      list.add(
        Positioned(
          child: CircleButton(
              onTap: () => model.setTonic(note),
              //iconData: Icons.favorite_border,
              text: noteDisplayName.toString(),
              ),
          top: y - cw / 2,
          right: x - cw / 2,
          width: cw,
          height: cw,
        ),
      );
    }

    return list;
  }
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  //final IconData iconData;
  final String text;

  const CircleButton({
    Key key,
    this.onTap,
    //this.iconData,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 50.0;

    return InkResponse(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(child: Text(text)),
        // Icon(
        //   iconData,
        //   color: Colors.black,
        // ),
      ),
    );
  }
}
