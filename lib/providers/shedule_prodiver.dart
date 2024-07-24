import 'dart:convert';

import 'package:assistance_flutter/models/get_shedule_response.dart';
import 'package:assistance_flutter/services/schedule.service.dart';
import 'package:flutter/material.dart';

class ScheduleProviderModel with ChangeNotifier {
  String _selectedDay = 'Monday';
  final ScheduleService _scheduleService = ScheduleService();
  bool isSheduleLoading = false;
  String? _errorMessage;
  List<Datum> scheduleData = [];
  String get selectedDay => _selectedDay;

  void selectDay(String day) {
    _selectedDay = day;
    notifyListeners();
  }

  List<Schedule> getSchedulesForSelectedDay() {
    final dayData = scheduleData.firstWhere(
      (datum) => datum.day == _selectedDay,
      orElse: () => Datum(day: _selectedDay, schedules: []),
    );
    return dayData.schedules;
  }

  Future<void> getSchedule() async {
    isSheduleLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _scheduleService.getSchedule('669356ac7fed0b6dc4ec5296');
      if (response.statusCode == 200) {
        final resp = GetScheduleResponse.fromJson(response.body);
        scheduleData = resp.data;
        notifyListeners();
      } else {
        _errorMessage = 'Usuario o contraseña incorrectos';
      }
    } catch (error) {
      _errorMessage = 'Error en la conexión';
    } finally {
      isSheduleLoading = false;
      notifyListeners();
    }
  }
}
