import 'package:client/authentication/screens/login_screen.dart';
import 'package:client/common/models/common_response.dart';
import 'package:client/common/models/user_session.dart';
import 'package:client/common/services/http_service.dart';
import 'package:client/common/services/secure_storage_service.dart';
import 'package:client/guardian/models/get_all_guardian_response.dart';
import 'package:flutter/material.dart';

class GuardianService {
  static Future<CommonResponse<GetAllGuardianResponse>> getAllGuardians(BuildContext context) async {
    UserSession? user = await SecureStorageService.getSession();

    if (user == null) {
      Future.delayed(Duration.zero).then((value) =>
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          )));
    }

    dynamic response = await HttpService().get("sos/${user?.id}/guardian");
    CommonResponse<GetAllGuardianResponse> data = CommonResponse.fromJson(response, (json) =>  GetAllGuardianResponse.fromJson(json));

    return data;
  }
}