import 'dart:convert';

class CommonResponse<T> {
  String message;
  T? content;
  int statusCode;
  bool isSuccess;

  CommonResponse({
    required this.message,
    this.content,
    required this.statusCode,
    required this.isSuccess,
  });

  factory CommonResponse.fromJson(Map<String, dynamic> json,
      [T Function(dynamic)? fromJsonT]) {
    dynamic content =
        json["content"] != null ? fromJsonT?.call(json["content"]) : null;

    return CommonResponse(
      message: json["message"],
      content: content,
      isSuccess: json["isSuccess"],
      statusCode: json["statusCode"],
    );
  }
}

CommonResponse<T> commonResponseFromJson<T>(String str,
        [T Function(dynamic)? fromJsonT]) =>
    CommonResponse.fromJson(json.decode(str), fromJsonT);
