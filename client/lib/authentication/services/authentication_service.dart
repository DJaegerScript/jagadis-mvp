import 'package:jagadis/authentication/models/login_response.dart';
import 'package:jagadis/common/models/common_response.dart';
import 'package:jagadis/common/services/http_service.dart';
import 'package:jagadis/common/services/secure_storage_service.dart';

class AuthenticationService {
  static Future<CommonResponse> registerUser(Map<String, String> body) async {
    dynamic response = await HttpService()
        .post("auth/registration", body, isAuthenticated: false);

    CommonResponse data = CommonResponse.fromJson(response);

    return data;
  }

  static Future<CommonResponse<LoginResponse>> loginUser(
      Map<String, String> body) async {
    dynamic response =
        await HttpService().post("auth/login", body, isAuthenticated: false);
    CommonResponse<LoginResponse> data = CommonResponse.fromJson(
        response, (json) => LoginResponse.fromJson(json));

    return data;
  }

  static Future<CommonResponse> logoutUser() async {
    dynamic response =
        await HttpService().post("auth/logout", {}, isAuthenticated: true);
    CommonResponse<LoginResponse> data = CommonResponse.fromJson(response);

    return data;
  }

  static Future<bool> isAuthenticated() async {
    String? token = await SecureStorageService.read("token");

    // TODO: Check user existence
    return token != null;
  }
}
