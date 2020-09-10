import 'package:flutter/material.dart';

enum AppPage {
  Home,
  FindChord,
  MakeScale,
  Composer
}

class ViewModelHome extends ChangeNotifier {

  AppPage _kCurrentPage = AppPage.Home;
  AppPage get getCurrentPage => _kCurrentPage;
  void setCurrentPage(AppPage page) {
    _kCurrentPage = page;
    notifyListeners();
  }

}