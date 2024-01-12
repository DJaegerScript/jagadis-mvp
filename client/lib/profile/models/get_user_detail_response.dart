// To parse this JSON data, do
//
//     final userDetailResponse = userDetailResponseFromJson(jsonString);

import 'dart:convert';

UserDetailResponse userDetailResponseFromJson(String str) => UserDetailResponse.fromJson(json.decode(str));

String userDetailResponseToJson(UserDetailResponse data) => json.encode(data.toJson());

class UserDetailResponse {
    UserDetail user;

    UserDetailResponse({
        required this.user,
    });

    factory UserDetailResponse.fromJson(Map<String, dynamic> json) => UserDetailResponse(
        user: UserDetail.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
    };
}

class UserDetail {
    String id;
    String name;
    String email;
    String phoneNumber;
    String gender;
    String city;
    DateTime birthdate;

    UserDetail({
        required this.id,
        required this.name,
        required this.email,
        required this.phoneNumber,
        required this.gender,
        required this.city,
        required this.birthdate,
    });

    factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        gender: json["gender"],
        city: json["city"],
        birthdate: DateTime.parse(json["birthdate"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "city": city,
        "birthdate": birthdate.toIso8601String(),
    };
}
