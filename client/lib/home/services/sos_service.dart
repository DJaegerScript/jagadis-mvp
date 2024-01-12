import 'package:client/common/models/common_response.dart';
import 'package:client/common/services/http_service.dart';
import 'package:client/home/models/get_all_activated_alert_response.dart';

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

  static Future<CommonResponse> enterStandbyMode(
      Map<String, double> bodyRequest, String userId) async {
    dynamic response =
        await HttpService().post("sos/$userId/alert", bodyRequest);

    CommonResponse data = CommonResponse.fromJson(response);

    return data;
  }

  static Future<CommonResponse> updateAlert(
      Map<String, double> bodyRequest, String action, String userId) async {
    dynamic response = await HttpService()
        .put("sos/$userId/alert?action=$action", bodyRequest);

    CommonResponse data = CommonResponse.fromJson(response);

    return data;
  }
}
