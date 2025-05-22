import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  bool? status;
  String? token;
  String? message;
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;

  UserLogin({
    this.status,
    this.token,
    this.message,
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      status: true,
      token: json['token'],
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
    );
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(toJson()));
  }

  static Future<UserLogin?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('userData');
    if (jsonString != null) {
      return UserLogin.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'token': token,
        'id': id,
        'username': username,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
      };
}