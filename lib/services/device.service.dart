import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {



  Future<Map<String, dynamic>> getAndroidId() async {
    
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    log('BRANCH: ${androidInfo.brand}');

    log('DISPLAY: ${androidInfo.display}');

    log('ID: ${androidInfo.id}');
    log('MODEL: ${androidInfo.model}');

    Map<String, dynamic> data = {
      "brand": androidInfo.brand,
      "display": androidInfo.display,
      "device_id": androidInfo.id,
      "model": androidInfo.model
    };

    return data;
  }
}
