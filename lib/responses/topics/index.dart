// @dart=2.9
import 'package:forumbelajar/models/topics.dart';

class IndexTopicResponse {
  final bool error;
  final String message;
  final List<Topics> data;

  IndexTopicResponse({
    this.error, this.message, this.data
  });

  factory IndexTopicResponse.fromJson(Map<String, dynamic> json) {
    return IndexTopicResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: List<Topics>.from(json["data"].map((topic) {
        return Topics.fromJson(topic);
      }))
    );
  }

}