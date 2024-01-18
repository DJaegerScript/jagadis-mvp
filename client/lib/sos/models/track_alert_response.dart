// To parse this JSON data, do
//
//     final trackAlertResponse = trackAlertResponseFromJson(jsonString);

import 'dart:convert';

TrackAlertResponse trackAlertResponseFromJson(String str) =>
    TrackAlertResponse.fromJson(json.decode(str));

String trackAlertResponseToJson(TrackAlertResponse data) =>
    json.encode(data.toJson());

class TrackAlertResponse {
  Location location;
  User user;

  TrackAlertResponse({
    required this.location,
    required this.user,
  });

  factory TrackAlertResponse.fromJson(Map<String, dynamic> json) =>
      TrackAlertResponse(
        location: Location.fromJson(json["location"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "user": user.toJson(),
      };
}

class Location {
  double longitude;
  double latitude;

  Location({
    required this.longitude,
    required this.latitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
      };
}

class User {
  String id;
  String userId;
  String phoneNumber;
  String? name;
  DateTime activatedAt;

  User({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    this.name,
    required this.activatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userId: json["user_id"],
        phoneNumber: json["phone_number"],
        name: json["name"],
        activatedAt: DateTime.parse(json["activated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "phone_number": phoneNumber,
        "name": name,
        "activated_at": activatedAt.toIso8601String(),
      };
}
