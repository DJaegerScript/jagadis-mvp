import 'package:client/authentication/screens/login_screen.dart';
import 'package:client/common/models/common_response.dart';
import 'package:client/common/models/user_session.dart';
import 'package:client/common/services/secure_storage_service.dart';
import 'package:client/home/models/get_all_guardian_response.dart';
import 'package:client/home/services/guardian_service.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';

class GuardianViewModel extends ChangeNotifier {
  bool isLoading = false;
  String _phoneNumber = "";
  late Future<CommonResponse<GetAllGuardianResponse>> guardians;

  GuardianViewModel() {
    guardians = getAllGuardians();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  void refreshGuardians() {
    guardians = getAllGuardians();
    notifyListeners();
  }

  Future<CommonResponse<GetAllGuardianResponse>> getAllGuardians() async {
    UserSession? user = await SecureStorageService.getSession();

    if (user == null) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );

      throw Exception("Session expired!");
    }

    CommonResponse<GetAllGuardianResponse> response =
        await GuardianService.getAllGuardians(user.id);

    return response;
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

  Future<CommonResponse> removeGuardian(String guardianId) async {
    UserSession? user = await SecureStorageService.getSession();

    if (user == null) {
      throw Exception("Session expired!");
    }

    CommonResponse response =
        await GuardianService.removeGuardian(user.id, guardianId);

    return response;
  }

  Future<CommonResponse> resetGuardian() async {
    UserSession? user = await SecureStorageService.getSession();

    if (user == null) {
      throw Exception("Session expired!");
    }

    CommonResponse response = await GuardianService.resetGuardian(
      user.id,
    );

    return response;
  }
}
