import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'service_settings.dart';

class ViewModelStartup extends ChangeNotifier {

  final ServiceSettings _serviceSettings = GetIt.I.get<ServiceSettings>();

  ViewModelStartup(){
    loadSettings();
  }

  Future<void> loadSettings() async {

    await _serviceSettings.loadSettings();

    notifyListeners();

  }

  bool get isReady => _serviceSettings.isReady;

}