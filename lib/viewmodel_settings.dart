import 'package:accordi/service_scale.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'service_settings.dart';

class ViewModelSettings extends ChangeNotifier {

  final ServiceSettings _serviceSettings = GetIt.I.get<ServiceSettings>();

  bool getNoteEnharmonic() => 
    _serviceSettings.getNoteEnharmonic == NoteEnharmonic.Bemolle;
  Future<void> setNoteEnharmonic(bool value) async { 
    await _serviceSettings.setNoteEnharmonic( 
    value ? NoteEnharmonic.Bemolle : NoteEnharmonic.Diesis );
    notifyListeners();
  }

  bool getNoteLang() => 
    _serviceSettings.getNoteLang == NoteLang.Ita;
  Future<void> setNoteLang(bool value) async { 
    await _serviceSettings.setNoteLang( 
    value ? NoteLang.Ita : NoteLang.Eng );
    notifyListeners();
  }

  int get getBpm => _serviceSettings.getBpm;
  Future<void> incBpm(int n) async {
    await _serviceSettings.setBpm( _serviceSettings.getBpm+n );
    notifyListeners();
  }
  Future<void> decBpm(int n) async {
    await _serviceSettings.setBpm( _serviceSettings.getBpm-n );
    notifyListeners();
  }

}