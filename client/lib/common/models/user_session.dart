class UserSession {
  String id;
  String name;
  String email;
  String phoneNumber;
  String gender;
  String city;
  DateTime birthdate;

  UserSession({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.city,
    required this.birthdate,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
    id: json["id"],
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    gender: json['gender'],
    city: json['city'],
    birthdate: DateTime.parse(json['birthdate']),
  );
}