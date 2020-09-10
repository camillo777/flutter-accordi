import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'service_settings.dart';

class ViewModelAudioToggle extends ChangeNotifier {

final ServiceSettings _serviceSettings = GetIt.I.get<ServiceSettings>();

ViewModelAudioToggle(){
  _bAudioOn = _serviceSettings.getAudioOn;
}

  bool _bAudioOn;
  bool get getAudioOn => _bAudioOn;
  Future<void> toggleAudioOn() async { 
    _bAudioOn = !_bAudioOn; 
    await _serviceSettings.setAudioOn(_bAudioOn);
    notifyListeners(); 
  }

}