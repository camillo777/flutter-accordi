// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:accordi/service_scale.dart';

void main() {
  ServiceScale service = ServiceScale();
  service.setSelectedTonic("C#");
  service.setSelectedScaleType(service.getScaleTypes.singleWhere((scale)=>scale.name=="maggiore"));
  service.makeScale();
}
