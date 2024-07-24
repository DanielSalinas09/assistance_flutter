class DayHelper {
  static const Map<String, String> _dayMap = {
    'Lu': 'Monday',
    'Ma': 'Tuesday',
    'Mi': 'Wednesday',
    'Ju': 'Thursday',
    'Vi': 'Friday',
    'Sa': 'Saturday',
  };


  static final Map<String, String> _reverseDayMap = 
      _dayMap.map((key, value) => MapEntry(value, key));


  static String parseDay(String value, {bool reverse = false}) {
    if (reverse) {
      return _reverseDayMap[value] ?? 'Unknown abbreviation';
    } else {
      return _dayMap[value] ?? 'Unknown day';
    }
  }
}
