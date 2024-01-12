import 'package:client/common/models/common_response.dart';
import 'package:client/common/models/user_session.dart';
import 'package:client/common/services/secure_storage_service.dart';
import 'package:client/home/services/sos_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SOSViewModel extends ChangeNotifier {
  bool isStandby = false;

  void setIsStandby(bool value) {
    isStandby = value;
    notifyListeners();
  }

  Future<String> enterStandbyMode(Position position) async {
    Map<String, double> body = {
      "latitude": position.latitude,
      "longitude": position.longitude,
    };

    UserSession? user = await SecureStorageService.getSession();

    if (user == null) {
      throw "Session expired!";
    }

    CommonResponse response = await SOSService.enterStandbyMode(body, user.id);

    if (response.isSuccess) {
      return "Standby mode diaktifkan!";
    } else {
      throw response.message;
    }
  }

  Future<String> updateAlert(Position position, String action) async {
    Map<String, double> body = {
      "latitude": position.latitude,
      "longitude": position.longitude,
    };

    UserSession? user = await SecureStorageService.getSession();

    if (user == null) {
      throw "Session expired!";
    }

    CommonResponse response =
        await SOSService.updateAlert(body, action, user.id);

    if (response.isSuccess) {
      return "Sinyal berhasil diupdate!";
    } else {
      throw response.message;
    }
  }
}
