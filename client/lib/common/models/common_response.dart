import 'dart:convert';

class CommonResponse<T> {
  String message;
  T? content;
  int statusCode;
  bool isSuccess;

  CommonResponse({
    required this.message,
    required this.content,
    required this.statusCode,
    required this.isSuccess,
  });

  factory CommonResponse.fromJson(Map<String, dynamic> json, [T Function(dynamic)? fromJsonT]) {
    return CommonResponse(
      message: json["message"],
      content: fromJsonT?.call(json["content"]),
      isSuccess: json["isSuccess"],
      statusCode: json["statusCode"],
    );
  }
}

CommonResponse<T> commonResponseFromJson<T>(String str, [T Function(dynamic)? fromJsonT]) =>
    CommonResponse.fromJson(json.decode(str), fromJsonT);