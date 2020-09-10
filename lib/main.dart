import 'package:accordi/viewmodel_audiotoggle.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'service_scale.dart';
import 'service_settings.dart';
import 'view_home.dart';
import 'view_test.dart';
import 'viewmodel_choose.dart';
import 'viewmodel_home.dart';
import 'viewmodel_settings.dart';
import 'viewmodel_startup.dart';

void main() {
  GetIt.I.registerLazySingleton<ServiceScale>(() => ServiceScale());
  GetIt.I.registerSingleton<ServiceSettings>(ServiceSettings());

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<ViewModelStartup>(
              create: (_) => ViewModelStartup()),
          ChangeNotifierProvider<ViewModelHome>(create: (_) => ViewModelHome()),
          ChangeNotifierProvider<ViewModelChoose>(create: (_) => ViewModelChoose()),
          ChangeNotifierProvider<ViewModelAudioToggle>(
              create: (_) => ViewModelAudioToggle()),
          ChangeNotifierProvider<ViewModelSettings>(
              create: (_) => ViewModelSettings()),
        ], child: MaterialApp(
      title: 'Accordi',
      debugShowCheckedModeBanner: false,
      home: 
        Consumer<ViewModelStartup>(
          builder: (_, modelStartup, child) => ViewHome(), //ViewHome(),
        ),
      ),
    ),
  );
}
