import 'package:client/common/models/common_response.dart';
import 'package:client/common/services/http_service.dart';

class SOSService {
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
