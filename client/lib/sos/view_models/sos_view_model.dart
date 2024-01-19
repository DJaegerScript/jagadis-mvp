import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jagadis/common/models/common_response.dart';
import 'package:jagadis/common/models/user_session.dart';
import 'package:jagadis/common/services/secure_storage_service.dart';
import 'package:jagadis/common/services/utility_service.dart';
import 'package:jagadis/sos/models/enter_standby_mode_response.dart';
import 'package:jagadis/sos/models/get_all_activated_alert_response.dart';
import 'package:jagadis/sos/models/track_alert_response.dart';
import 'package:jagadis/sos/services/sos_service.dart';

class SOSViewModel extends ChangeNotifier {
  bool isStandby;
  AnimationController? controller;
  late Animation<double> animation;

  SOSViewModel(this.isStandby, this.controller) {
    double begin = 0;
    double end = 246 - 246 * 0.5;

    if (controller != null) {
      animation = Tween<double>(
              begin: isStandby ? end : begin, end: isStandby ? begin : end)
          .animate(controller!);
    }
  }

  void setIsStandby(bool value) {
    isStandby = value;
    notifyListeners();
  }

  Future<GetAllActivatedAlertResponse> getAllActivatedAlert() async {
    UserSession? user = await SecureStorageService.getSession();

    if (user == null) {
      throw "Session expired!";
    }

    CommonResponse<GetAllActivatedAlertResponse> response =
        await SOSService.getAllActivatedAlert(user.id);

    if (response.isSuccess) {
      return response.content!;
    } else {
      throw response.message;
    }
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

    CommonResponse<EnterStandbyModeResponse> response =
        await SOSService.enterStandbyMode(body, user.id);

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

  Future<TrackAlertResponse> trackAlert(String userId, String alertId) async {
    CommonResponse<TrackAlertResponse> response =
        await SOSService.trackAlert(userId, alertId);

    if (response.isSuccess) {
      return response.content!;
    } else {
      throw response.message;
    }
  }

  Future<String> handleSwitch() async {
    String message = "";
    try {
      Position position = await UtilityService.getCurrentPosition();

      if (!isStandby) {
        message = await enterStandbyMode(position);

        if (animation.status == AnimationStatus.dismissed) {
          await controller?.forward();
        } else {
          await controller?.reverse();
        }

        await SecureStorageService.write("standbyStatus", isStandby.toString());
      } else {
        if (animation.status == AnimationStatus.dismissed) {
          await controller?.forward();
        } else {
          await controller?.reverse();
        }

        message = await updateAlert(position, "TURNED_OFF");
        await SecureStorageService.destroy("standbyStatus");
      }

      setIsStandby(!isStandby);

      return message;
    } catch (error) {
      if (!isStandby) {
        if (animation.status == AnimationStatus.dismissed) {
          await controller?.forward();
        } else {
          await controller?.reverse();
        }
      } else {
        if (animation.status == AnimationStatus.dismissed) {
          await controller?.forward();
        } else {
          await controller?.reverse();
        }
      }

      setIsStandby(!isStandby);

      return "$error";
    }
  }
}
