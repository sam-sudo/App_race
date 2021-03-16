import 'dart:convert';

import 'package:flutter/material.dart';

class UserCredentials {
  String email;
  String password;

  UserCredentials({@required this.email, this.password});

  UserCredentials.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  /*static UserCredentials fromJson(String userJson) {
    final userMap = jsonDecode(userJson);
    return UserCredentials(email: userMap['email']);
  }*/
/*
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
      */

  String toJson() => json.encode(toMap());
  String emailToJson() => json.encode(emailToMap());

  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
      };

  Map<String, dynamic> emailToMap() => {'email': email};

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserCredentials && o.email == email;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
