import 'dart:convert';

import 'package:app_races/src/models/UserCredentials.dart';

class User extends UserCredentials {
  int id;
  String username;
  String lastname;

  User({this.id, this.username, this.lastname, email, password})
      : super(email: email, password: password);

  int getId() {
    return this.id;
  }

  String getUsername() {
    return this.username;
  }

  void setUsername(String newUsername) {
    this.username = newUsername;
  }

  String getLastname() {
    return this.lastname;
  }

  void setLastname(String newLastname) {
    this.lastname = newLastname;
  }

  String getEmail() {
    return this.email;
  }

  void setEmail(String newEmail) {
    this.email = newEmail;
  }

  String getPassword() {
    return this.password;
  }

  void setPassword(String newPassword) {
    this.password = newPassword;
  }

  static User fromJson(String userJson) {
    final userMap = jsonDecode(userJson);
    return User(
        id: userMap['_id'],
        email: userMap['email'],
        password: userMap['password']);
  }
}
