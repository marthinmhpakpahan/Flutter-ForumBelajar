// @dart=2.9
import 'package:forumbelajar/models/topics.dart';

class DetailsTopicResponse {
  final bool error;
  final String message;
  final Topics data;

  DetailsTopicResponse({
    this.error, this.message, this.data
  });

  factory DetailsTopicResponse.fromJson(Map<String, dynamic> json) {
    return DetailsTopicResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: Topics.fromJson(json['data'])
    );
  }

}