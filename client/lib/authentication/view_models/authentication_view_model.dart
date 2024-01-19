import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jagadis/authentication/models/login_response.dart';
import 'package:jagadis/authentication/screens/login_screen.dart';
import 'package:jagadis/authentication/services/authentication_service.dart';
import 'package:jagadis/common/models/common_response.dart';
import 'package:jagadis/common/services/secure_storage_service.dart';
import 'package:jagadis/main.dart';
import 'package:jagadis/sos/screens/home_screen.dart';

class AuthenticationViewModel extends ChangeNotifier {
  String _email = "";
  String _password = "";
  String _confirmationPassword = "";
  String _phoneNumber = "";

  String getEmail() {
    return _email;
  }

  String getPassword() {
    return _password;
  }

  String getConfirmationPassword() {
    return _confirmationPassword;
  }

  String getPhoneNumber() {
    return _phoneNumber;
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setConfirmationPassword(String confirmationPassword) {
    _confirmationPassword = confirmationPassword;
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  void login() async {
    Map<String, String> body = {
      "email": _email,
      "password": _password,
    };

    CommonResponse<LoginResponse> response =
        await AuthenticationService.loginUser(body);

    if (response.isSuccess) {
      String user = response.content?.user != null
          ? jsonEncode(response.content?.user)
          : "";

      await SecureStorageService.write("user", user);
      await SecureStorageService.write("token", response.content?.token ?? "");

      navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } else {
      scaffoldMessengerKey.currentState
          ?.showSnackBar(SnackBar(content: Text(response.message)));
    }
  }

  void register() async {
    String formattedPhoneNumber = _phoneNumber.startsWith("62")
        ? "+$_phoneNumber"
        : _phoneNumber.startsWith("0")
            ? _phoneNumber.replaceFirst("0", "+62")
            : !_phoneNumber.startsWith("62") && !_phoneNumber.startsWith("0")
                ? "+62$_phoneNumber"
                : _phoneNumber;

    Map<String, String> body = {
      "phoneNumber": formattedPhoneNumber,
      "email": _email,
      "password": _password,
      "confirmationPassword": _confirmationPassword
    };

    CommonResponse response = await AuthenticationService.registerUser(body);

    if (response.isSuccess) {
      navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ));
    } else {
      scaffoldMessengerKey.currentState
          ?.showSnackBar(SnackBar(content: Text(response.message)));
    }
  }
}
