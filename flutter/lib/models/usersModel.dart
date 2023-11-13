import 'dart:convert';

List<UsersModel> UsersModelFromJson(String str) =>
    List<UsersModel>.from(json.decode(str).map((x) => UsersModel.fromMap(x)));

class UsersModel {
  String id;
  String Name;
  String email;
  String role;
  String isAgent;
  String StatutAgent;

  UsersModel(
      {required this.id,
      required this.Name,
      required this.email,
      required this.role,
      required this.isAgent,
      required this.StatutAgent});
  factory UsersModel.fromMap(Map<String, dynamic> json) {
    return UsersModel(
        id: json['_id'],
        Name: json['name'],
        email: json['email'],
        role: json['role'],
        isAgent: json['isAgent'],
        StatutAgent: json['StatutAgent']);
  }
}
