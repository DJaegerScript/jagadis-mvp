import 'package:jagadis/authentication/screens/login_screen.dart';
import 'package:jagadis/common/models/common_response.dart';
import 'package:jagadis/common/models/user_session.dart';
import 'package:jagadis/common/services/http_service.dart';
import 'package:jagadis/common/services/secure_storage_service.dart';
import 'package:jagadis/profile/models/get_user_detail_response.dart';
import 'package:flutter/material.dart';

class ProfileService {
  static Future<CommonResponse<UserDetailResponse>> getUserDetail(
      BuildContext context) async {
    UserSession? user = await SecureStorageService.getSession();

    if (user == null) {
      Future.delayed(Duration.zero).then(
          (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              )));
    }

    dynamic response = await HttpService().get("user/${user?.id}/profile");
    CommonResponse<UserDetailResponse> data = CommonResponse.fromJson(
        response, (json) => UserDetailResponse.fromJson(json));

    return data;
  }

  static Future<CommonResponse> updateUserDetail(
      BuildContext context, Map<String, String> body) async {
    UserSession? user = await SecureStorageService.getSession();

    if (user == null) {
      Future.delayed(Duration.zero).then(
          (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              )));
    }

    dynamic response =
        await HttpService().put("user/${user?.id}/profile", body);
    CommonResponse data = CommonResponse.fromJson(response);

    return data;
  }
}
