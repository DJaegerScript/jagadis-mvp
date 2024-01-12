import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jagadis/authentication/screens/login_screen.dart';
import 'package:jagadis/authentication/services/authentication_service.dart';
import 'package:jagadis/common/services/secure_storage_service.dart';
import 'package:jagadis/main.dart';
import 'package:path/path.dart' as path;

class HttpService {
  // TODO: make dynamic from .env
  static const String _baseUrl = "https://e8b1-182-253-127-167.ngrok-free.app";
  static final Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  Future get(String endpoint, {bool isAuthenticated = true}) async {
    Uri url = Uri.parse(path.join(_baseUrl, endpoint));

    await _authorizeHeader(isAuthenticated);

    Response response = await http.get(url, headers: headers);
    if (response.statusCode == 401 && endpoint != 'auth/login') {
      _handleUnauthorizedRequest();
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future post(String endpoint, Map<String, dynamic> body,
      {bool isAuthenticated = true}) async {
    Uri url = Uri.parse(path.join(_baseUrl, endpoint));

    await _authorizeHeader(isAuthenticated);

    Response response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 401 && endpoint != 'auth/login') {
      _handleUnauthorizedRequest();
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future put(String endpoint, Map<String, dynamic> body,
      {bool isAuthenticated = true}) async {
    Uri url = Uri.parse(path.join(_baseUrl, endpoint));

    await _authorizeHeader(isAuthenticated);

    Response response =
        await http.put(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 401 && endpoint != 'auth/login') {
      _handleUnauthorizedRequest();
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future patch(String endpoint, Map<String, dynamic> body,
      {bool isAuthenticated = true}) async {
    Uri url = Uri.parse(path.join(_baseUrl, endpoint));

    await _authorizeHeader(isAuthenticated);

    Response response =
        await http.patch(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 401 && endpoint != 'auth/login') {
      _handleUnauthorizedRequest();
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future delete(String endpoint, {bool isAuthenticated = true}) async {
    Uri url = Uri.parse(path.join(_baseUrl, endpoint));

    await _authorizeHeader(isAuthenticated);

    Response response = await http.delete(url, headers: headers);

    if (response.statusCode == 401 && endpoint != 'auth/login') {
      _handleUnauthorizedRequest();
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  static Future<void> _authorizeHeader(bool isAuthenticated) async {
    if (isAuthenticated) {
      String? token = await SecureStorageService.read("token");

      if (await AuthenticationService.isAuthenticated()) {
        headers['Authorization'] = "Bearer $token";
      } else {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  static void _handleUnauthorizedRequest() async {
    await SecureStorageService.destroyAll();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}
