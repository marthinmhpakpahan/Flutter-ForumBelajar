// @dart=2.9
import 'dart:ffi';

import 'package:forumbelajar/models/users.dart';

class LoginResponse {
  final bool error;
  final String message;
  final Users data;

  LoginResponse({
    this.error, this.message, this.data
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: (json['data'].length == 0 ? null : Users.fromJson(json['data']))
    );
  }

}