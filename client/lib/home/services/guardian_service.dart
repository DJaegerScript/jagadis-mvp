import 'package:client/common/models/common_response.dart';
import 'package:client/common/services/http_service.dart';
import 'package:client/home/models/get_all_guardian_response.dart';

class GuardianService {
  static Future<CommonResponse<GetAllGuardianResponse>> getAllGuardians(
      String userId) async {
    dynamic response = await HttpService().get("sos/$userId/guardian");
    CommonResponse<GetAllGuardianResponse> data = CommonResponse.fromJson(
        response, (json) => GetAllGuardianResponse.fromJson(json));

    return data;
  }

  static Future<CommonResponse> addGuardian(
      Map<String, String> bodyRequest, String userId) async {
    dynamic response =
        await HttpService().post("sos/$userId/guardian", bodyRequest);
    CommonResponse data = CommonResponse.fromJson(response);

    return data;
  }

  static Future<CommonResponse> removeGuardian(
      String userId, String guardianId) async {
    dynamic response =
        await HttpService().delete("sos/$userId/guardian/$guardianId");
    CommonResponse data = CommonResponse.fromJson(response);

    return data;
  }
}
