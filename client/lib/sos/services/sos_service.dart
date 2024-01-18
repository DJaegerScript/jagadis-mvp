import 'package:jagadis/common/models/common_response.dart';
import 'package:jagadis/common/services/http_service.dart';
import 'package:jagadis/sos/models/enter_standby_mode_response.dart';
import 'package:jagadis/sos/models/get_all_activated_alert_response.dart';
import 'package:jagadis/sos/models/track_alert_response.dart';

class SOSService {
  static Future<CommonResponse<GetAllActivatedAlertResponse>>
      getAllActivatedAlert(String userId) async {
    dynamic response = await HttpService().get(
      "sos/$userId/alert",
    );

    CommonResponse<GetAllActivatedAlertResponse> data = CommonResponse.fromJson(
        response, (json) => GetAllActivatedAlertResponse.fromJson(json));

    return data;
  }

  static Future<CommonResponse<EnterStandbyModeResponse>> enterStandbyMode(
      Map<String, double> bodyRequest, String userId) async {
    dynamic response =
        await HttpService().post("sos/$userId/alert", bodyRequest);

    CommonResponse<EnterStandbyModeResponse> data = CommonResponse.fromJson(
        response, (json) => EnterStandbyModeResponse.fromJson(json));

    return data;
  }

  static Future<CommonResponse> updateAlert(
      Map<String, double> bodyRequest, String action, String userId) async {
    dynamic response = await HttpService()
        .put("sos/$userId/alert?action=$action", bodyRequest);

    CommonResponse data = CommonResponse.fromJson(response);

    return data;
  }

  static Future<CommonResponse<TrackAlertResponse>> trackAlert(
      String userId, String alertId) async {
    dynamic response = await HttpService().get("sos/$userId/alert/$alertId");

    CommonResponse<TrackAlertResponse> data = CommonResponse.fromJson(
        response, (json) => TrackAlertResponse.fromJson(json));

    return data;
  }
}
