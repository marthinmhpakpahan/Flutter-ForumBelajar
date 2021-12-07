// @dart=2.9
import 'package:forumbelajar/models/users.dart';
class DetailUserResponse {
  final bool error;
  final String message;
  final Users data;

  DetailUserResponse({
    this.error, this.message, this.data
  });

  factory DetailUserResponse.fromJson(Map<String, dynamic> json) {
    return DetailUserResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: Users.fromJson(json['data'])
    );
  }

}