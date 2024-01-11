// To parse this JSON data, do
//
//     final getAllGuardianResponse = getAllGuardianResponseFromJson(jsonString);

import 'dart:convert';

GetAllGuardianResponse getAllGuardianResponseFromJson(String str) =>
    GetAllGuardianResponse.fromJson(json.decode(str));

String getAllGuardianResponseToJson(GetAllGuardianResponse data) =>
    json.encode(data.toJson());

class GetAllGuardianResponse {
  List<Guardian> guardians;

  GetAllGuardianResponse({
    required this.guardians,
  });

  factory GetAllGuardianResponse.fromJson(Map<String, dynamic> json) =>
      GetAllGuardianResponse(
        guardians: List<Guardian>.from(
            json["guardians"].map((x) => Guardian.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "guardians": List<dynamic>.from(guardians.map((x) => x.toJson())),
      };
}

class Guardian {
  String id;
  String contactNumber;
  String? name;

  Guardian({
    required this.id,
    required this.contactNumber,
    this.name,
  });

  factory Guardian.fromJson(Map<String, dynamic> json) => Guardian(
      id: json["id"],
      contactNumber: json["contact_number"],
      name: json["name"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "contact_number": contactNumber, "name": name};
}
