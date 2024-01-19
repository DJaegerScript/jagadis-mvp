import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jagadis/authentication/models/login_response.dart';
import 'package:jagadis/authentication/services/authentication_service.dart';
import 'package:jagadis/common/models/common_response.dart';
import 'package:jagadis/common/services/secure_storage_service.dart';
import 'package:jagadis/main.dart';
import 'package:jagadis/sos/screens/home_screen.dart';

class AuthenticationViewModel extends ChangeNotifier {
  String _email = "";
  String _password = "";

  String getEmail() {
    return _email;
  }

  String getPassword() {
    return _email;
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
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
}
