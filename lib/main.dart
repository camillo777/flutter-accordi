import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'service_scale.dart';
import 'service_settings.dart';
import 'viewmodel_startup.dart';
import 'widget_home.dart';

void main() {
  GetIt.I.registerLazySingleton<ServiceScale>(() => ServiceScale());
  GetIt.I.registerSingleton<ServiceSettings>(ServiceSettings());

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
        body: 
        ChangeNotifierProvider<ViewModelStartup>(
          create: (_) => ViewModelStartup(),
          child: Consumer<ViewModelStartup>(
            builder: (_, model, child) => model.isReady?
        WidgetHome():
        CircularProgressIndicator(),
        ),
        ),
      ),
    );
  }
}
