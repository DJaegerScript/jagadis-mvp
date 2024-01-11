import 'package:client/common/models/common_response.dart';
import 'package:client/common/models/user_session.dart';
import 'package:client/common/services/secure_storage_service.dart';
import 'package:client/home/services/guardian_service.dart';
import 'package:flutter/material.dart';

class GuardianViewModel extends ChangeNotifier {
  bool isLoading = false;
  String _phoneNumber = "";

  void setLoading(bool value) {
    isLoading = value;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  Future<CommonResponse> addGuardian() async {
    String formattedPhoneNumber = _phoneNumber.startsWith("62")
        ? "+$_phoneNumber"
        : _phoneNumber.startsWith("0")
            ? _phoneNumber.replaceFirst("0", "+62")
            : _phoneNumber;

    Map<String, String> body = {
      "contactNumbers": formattedPhoneNumber,
    };

    UserSession? user = await SecureStorageService.getSession();

    if (user == null) {
      throw Exception("Session expired!");
    }

    CommonResponse response = await GuardianService.addGuardian(body, user.id);

    return response;
  }
}
