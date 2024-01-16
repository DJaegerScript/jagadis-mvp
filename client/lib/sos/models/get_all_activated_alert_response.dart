// To parse this JSON data, do
//
//     final getAllActivatedAlertResponse = getAllActivatedAlertResponseFromJson(jsonString);

import 'dart:convert';

GetAllActivatedAlertResponse getAllActivatedAlertResponseFromJson(String str) =>
    GetAllActivatedAlertResponse.fromJson(json.decode(str));

String getAllActivatedAlertResponseToJson(GetAllActivatedAlertResponse data) =>
    json.encode(data.toJson());

class GetAllActivatedAlertResponse {
  List<Alert> alerts;

  GetAllActivatedAlertResponse({
    required this.alerts,
  });

  factory GetAllActivatedAlertResponse.fromJson(Map<String, dynamic> json) =>
      GetAllActivatedAlertResponse(
        alerts: List<Alert>.from(json["alerts"].map((x) => Alert.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "alerts": List<dynamic>.from(alerts.map((x) => x.toJson())),
      };
}

class Alert {
  String id;
  String userId;
  String? name;
  String phoneNumber;
  DateTime activatedAt;

  Alert({
    required this.id,
    required this.userId,
    this.name,
    required this.phoneNumber,
    required this.activatedAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        activatedAt: DateTime.parse(json["activated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "phone_number": phoneNumber,
        "activated_at": activatedAt.toIso8601String(),
      };
}
