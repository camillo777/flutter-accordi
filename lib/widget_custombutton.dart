import 'package:flutter/material.dart';

import 'config.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final Function onPressed;
//   final bool enabled;
//   final bool dark;

//   CustomButton({
//     @required this.text,
//     @required this.onPressed,
//     this.enabled = true,
//     this.dark = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return RaisedButton(
//       onPressed: enabled ? onPressed : null,
//       color: dark ? Config.COLOR_LA : Config.COLOR_DA,
//       child: Text(text,
//           style: TextStyle(
//             color: dark ? Config.COLOR_DA : Config.COLOR_LA,
//             fontSize: 34,
//             fontWeight: FontWeight.bold,
//           )),
//     );
//   }
// }

// class MyRoundButton extends StatelessWidget {
//   final String textBold;
//   final String textNormal;
//   final Function onPressed;
//   final bool enabled;
//   final bool dark;

//   MyRoundButton({
//     this.textBold,
//     this.textNormal,
//     @required this.onPressed,
//     this.enabled = true,
//     this.dark = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return RawMaterialButton(
//       onPressed: onPressed,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           textBold != null
//               ? Text("$textBold", style: Config.TS_BUTTON_DARK)
//               : SizedBox.shrink(),
//           textNormal != null
//               ? Text("$textNormal",
//                   style: Config.TS_VALUE.copyWith(color: Config.COLOR_LS))
//               : SizedBox.shrink(),
//         ],
//       ),
//       // Icon(
//       //    Icons.pause,
//       //    color: Colors.blue,
//       //    size: 35.0,
//       // ),
//       shape: CircleBorder(),
//       elevation: 2.0,
//       fillColor: Config.COLOR_DA,
//       padding: const EdgeInsets.all(7.0),
//     );
//   }
// }

class MyRoundButton2 extends StatelessWidget {
  final String textBold;
  final String textNormal;
  final Function onPressed;
  final bool enabled;
  final bool dark;
  final bool selected;

  MyRoundButton2({
    this.textBold,
    this.textNormal,
    @required this.onPressed,
    this.enabled = true,
    this.dark = true,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: ButtonTheme(
        minWidth: 0.0,
        //height: 100.0,
        child: RaisedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              textBold != null
                  ? TextTitle(text: "$textBold", dark: dark)
                  : SizedBox.shrink(),
              textNormal != null
                  ? TextValue(text: "$textNormal", dark: dark)
                  : SizedBox.shrink(),
            ],
          ),

          // Icon(
          //    Icons.pause,
          //    color: Colors.blue,
          //    size: 35.0,
          // ),
          shape: CircleBorder(
              //borderRadius: BorderRadius.circular(30.0),
              //side: BorderSide(color: Colors.red),
              ),
          elevation: 2.0,
          color: selected
              ? (dark ? Config.COLOR_DS : Config.COLOR_LS)
              : (dark ? Config.COLOR_DA : Config.COLOR_LA),
          padding: const EdgeInsets.all(7.0),
        ),
      ),
    );
  }
}

class MyRoundedEdgeButton extends StatelessWidget {
  final String textBold;
  final String textNormal;
  final Function onPressed;
  final bool enabled;
  final bool dark;
  final bool selected;

  MyRoundedEdgeButton({
    this.textBold,
    this.textNormal,
    @required this.onPressed,
    this.enabled = true,
    this.dark = true,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: ButtonTheme(
        minWidth: 0.0,
        //height: 100.0,
        child: RaisedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              textBold != null
                  ? TextTitle(text: "$textBold", dark: dark)
                  : SizedBox.shrink(),
              textNormal != null
                  ? TextValue(text: "$textNormal", dark: dark)
                  : SizedBox.shrink(),
            ],
          ),

          // Icon(
          //    Icons.pause,
          //    color: Colors.blue,
          //    size: 35.0,
          // ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            //side: BorderSide(color: Colors.red),
          ),
          elevation: 2.0,
          color: selected
              ? (dark ? Config.COLOR_DS : Config.COLOR_LS)
              : (dark ? Config.COLOR_DA : Config.COLOR_LA),
          padding: const EdgeInsets.all(7.0),
        ),
      ),
    );
  }
}

class MyRoundedEdgeText extends StatelessWidget {
  final String textBold;
  final String textNormal;
  final bool dark;
  final bool selected;
  final Function onPressed;
  final double width;

  MyRoundedEdgeText({
    this.textBold,
    this.textNormal,
    this.dark = true,
    this.selected = false, 
    this.onPressed, 
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return 
    ConstrainedBox(
  constraints: new BoxConstraints(
    minHeight: 50.0,
    minWidth: 50.0,),
      //width: 40,
      //height: 30,
      child: ClipRect( // if bigger clip it
        child: 
    Padding(
      padding: EdgeInsets.all(1),
      child: InkWell(
        onTap: onPressed,
        child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.horizontal(), // .circular(10),
        color: selected
            ? (dark ? Config.COLOR_DS : Config.COLOR_LS)
            : (dark ? Config.COLOR_DA : Config.COLOR_LA),
      ),
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            textBold != null
                ? TextTitle(text: "$textBold", dark: dark)
                : SizedBox.shrink(),
            textNormal != null
                ? TextValue(text: "$textNormal", dark: dark)
                : SizedBox.shrink(),
          ],
        ),
      ),
      //),
    ),),),),);
  }
}

// class MyColorRoundedEdgeButton extends StatelessWidget {
//   final String text1;
//   final String text2;
//   final Function onPressed;
//   final bool enabled;
//   final Color backgroundColor;

//   MyColorRoundedEdgeButton({
//     @required this.text1,
//     @required this.text2,
//     @required this.onPressed,
//     this.enabled = true,
//     this.backgroundColor = Config.COLOR_DA,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return RaisedButton(
//       onPressed: onPressed,
//       child: Row(
//         children: <Widget>[
//           Text("$text1", style: Config.TS_BUTTON_DARK),
//           Text("$text2",
//               style:
//                   Config.TS_BUTTON_DARK.copyWith(fontWeight: FontWeight.normal))
//         ],
//       ),
//       // Icon(
//       //    Icons.pause,
//       //    color: Colors.blue,
//       //    size: 35.0,
//       // ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//         //side: BorderSide(color: Colors.red),
//       ),
//       elevation: 2.0,
//       color: backgroundColor,
//       padding: const EdgeInsets.all(15.0),
//     );
//   }
// }

class MyButtonCloseWindow extends StatelessWidget {
  final Function onPressed;
  final bool enabled;

  MyButtonCloseWindow({
    @required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Config.PADDING_BASE),
      child: IconButton(
        color: Config.COLOR_DA,
        onPressed: onPressed,
        icon: Icon(Icons.close, color: Config.COLOR_LA),
      ),
    );
  }
}

class TextTitle extends StatelessWidget {
  final String text;
  final bool dark;

  const TextTitle({Key key, @required this.text, this.dark = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: dark ? Config.TS_TITLE_DARK : Config.TS_TITLE_LIGH);
}

class TextLabel extends StatelessWidget {
  final String text;
  final bool dark;

  const TextLabel({Key key, @required this.text, this.dark = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: dark ? Config.TS_LABEL_DARK : Config.TS_LABEL_LIGH);
}

class TextValue extends StatelessWidget {
  final String text;
  final bool dark;

  const TextValue({Key key, @required this.text, this.dark = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: dark ? Config.TS_VALUE_DARK : Config.TS_VALUE_LIGH);
}

class TextValueBig extends StatelessWidget {
  final String text;
  final bool dark;

  const TextValueBig({Key key, @required this.text, this.dark = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Text(text,
      style: dark
          ? Config.TS_TITLE_DARK.copyWith(fontSize: 25)
          : Config.TS_TITLE_LIGH.copyWith(fontSize: 25));
}

class MyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
        height: 10,
        color: Colors.transparent,
      );
}

class MyDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const MyDialog({
    Key key,
    @required this.child,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(Config.PADDING_BASE),
          child: Container(
              width: MediaQuery.of(context).size.width *
                  Config.WIDTH_PERCENT_DIALOG,
              padding: EdgeInsets.all(Config.PADDING_BASE),
              decoration: BoxDecoration(
                color: Config.COLOR_LA,
                borderRadius: BorderRadius.all(
                  Radius.circular(Config.RADIUS_BASE),
                ),
              ),
              //color: Config.COLOR_LA,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[TextTitle(text: title), MyDivider(), child],
              )),
        ),
      ),
    );
  }
}
