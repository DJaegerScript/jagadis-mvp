// To parse this JSON data, do
//
//     final enterStandbyModeResponse = enterStandbyModeResponseFromJson(jsonString);

import 'dart:convert';

EnterStandbyModeResponse enterStandbyModeResponseFromJson(String str) =>
    EnterStandbyModeResponse.fromJson(json.decode(str));

String enterStandbyModeResponseToJson(EnterStandbyModeResponse data) =>
    json.encode(data.toJson());

class EnterStandbyModeResponse {
  String alertId;

  EnterStandbyModeResponse({
    required this.alertId,
  });

  factory EnterStandbyModeResponse.fromJson(Map<String, dynamic> json) =>
      EnterStandbyModeResponse(
        alertId: json["alertId"],
      );

  Map<String, dynamic> toJson() => {
        "alertId": alertId,
      };
}
