import 'dart:ui';

import 'package:flutter/material.dart';

import 'logger.dart';

const Color colorLightShade = Color(0xfff8f9f9);
const Color colorAccent = Color(0xffa9729c); //  0xff53c5c2);
const Color colorPrimary = Color(0xffef9b47);
const Color colorDarkShade = Color(0xff3d5e68);

class ViewTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLightShade,
      body: Column(
        children: <Widget>[
          Container(
            //color: Colors.red,
            width: double.infinity,
            height: 220,
            alignment: Alignment.topCenter,
            child: Stack(
              fit: StackFit.loose,
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(),
                Positioned(
                  right: 0,
                  // child: GestureDetector(
                  //   onTap: ,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.settings),
                  ),
                  ),
                //),
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          colorPrimary.withOpacity(1.0),
                          colorPrimary.withOpacity(0.6)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            color: colorLightShade,
                            fontSize: 30,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Che scala usiamo ",
                            ),
                            TextSpan(
                              text: "oggi?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                  ),
                ),
                Positioned(
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    bottom: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ButtonTonic(),
                        ButtonScala(),
                      ],
                    )),
              ],
            ),
          ),
          Row(
            children: <Widget>[],
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: colorLightShade,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(2, 2),
                      color: colorDarkShade,
                      blurRadius: 5)
                ]),
            child: Row(
              children: <Widget>[],
            ),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  final log = getLogger("MyClipper");
  @override
  Path getClip(Size size) {
    log.i(size);
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height + 10, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ButtonScala extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      //width: 100,
      height: 80,
      //color: Colors.green,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: colorAccent,
        borderRadius: BorderRadius.circular(15),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 5,
            color: colorDarkShade.withOpacity(0.1),
          )
        ],
      ),
      child: Text(
        "Maggiore",
        style: TextStyle(
          color: colorLightShade,
          fontSize: 30,
        ),
      ),
    );
  }
}

class ButtonTonic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorAccent,
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 5,
              color: colorDarkShade.withOpacity(0.1),
            ),
          ]),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: colorLightShade), 
          children: [
          TextSpan(
            text: "DO",
            style: TextStyle(fontSize: 30),
          )
        ]),
      ),
    );
  }
}

class ChordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 100,
      height: 140,
      //color: Colors.green,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: colorLightShade,
        borderRadius: BorderRadius.circular(15),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 5,
            color: colorDarkShade.withOpacity(0.1),
          )
        ],
      ),
      child: Text(
        "ciao",
        style: TextStyle(color: colorDarkShade),
      ),
    );
  }
}
