import 'package:flutter/material.dart';

class ScheduleProviderModel with ChangeNotifier {
  String _selectedDay = 'Lu';

  String get selectedDay => _selectedDay;

  void selectDay(String day) {
    _selectedDay = day;
    notifyListeners();
  }
}
