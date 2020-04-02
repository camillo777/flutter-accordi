import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'service_scale.dart';
import 'widget_home.dart';

void main() {
  GetIt.I.registerLazySingleton<ServiceScale>(() => ServiceScale());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accordi App',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Accordi"),
        ),
        body: WidgetHome(),
      ),
    );
  }
}
